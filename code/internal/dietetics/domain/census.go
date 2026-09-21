package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// MealCycle is which service a census is for (SRS-DIET-005).
type MealCycle string

const (
	CycleBreakfast MealCycle = "breakfast"
	CycleLunch     MealCycle = "lunch"
	CycleDinner    MealCycle = "dinner"
	CycleSnack     MealCycle = "snack"
)

var knownCycle = map[MealCycle]bool{
	CycleBreakfast: true, CycleLunch: true,
	CycleDinner: true, CycleSnack: true,
}

// CensusLine is one patient's place in a meal service (SRS-DIET-005).
type CensusLine struct {
	PatientID   string
	EncounterID string
	WardID      string
	BedID       string

	// OrderID pins the order this line was built from. The kitchen cooked to
	// a particular version of a particular order, and after a wrong tray
	// that is the first thing anybody asks.
	OrderID      string
	Route        Route
	TextureCode  string
	TextureLabel string
	FluidCode    string
	Restrictions []string
	Supplements  []string
	Instruction  string
}

// CensusState is where a meal census stands (SRS-DIET-005).
type CensusState string

const (
	CensusDraft CensusState = "draft"
	// CensusFrozen is the census at production cutoff: what the kitchen
	// cooked to. It is never edited after this.
	CensusFrozen CensusState = "frozen"
	// CensusSuperseded is a frozen census a later version replaced.
	CensusSuperseded CensusState = "superseded"
)

// MealCensus is what the kitchen produces for one ward and one service
// (SRS-DIET-005).
//
// Frozen at the production cutoff and versioned after it, never edited. The
// census is the kitchen's instruction and the hospital's record of what it
// was: a ward that got forty trays when the census said thirty-eight has a
// question, and a census that changed underneath the answer has none.
type MealCensus struct {
	ID       string
	TenantID string

	FacilityID  string
	WardID      string
	Cycle       MealCycle
	ServiceDate time.Time
	// CutoffAt is when production starts and the count stops being
	// negotiable.
	CutoffAt time.Time

	Lines []CensusLine

	State   CensusState
	Version int
	// SupersedesID chains a reissue back to the census it replaced, so the
	// whole sequence for one service is readable.
	SupersedesID string

	FrozenAt time.Time
	FrozenBy string

	BuiltAt time.Time
	BuiltBy string
}

// BuildCensus lists what to cook for one ward and one service
// (SRS-DIET-005).
//
// Built from the orders in force at the census moment, and only the oral
// ones: nil by mouth, enteral and parenteral produce no tray, and a kitchen
// that plates one for them is a kitchen that sends food to a patient who must
// not eat.
func BuildCensus(id, tenantID, facilityID, wardID string, cycle MealCycle,
	serviceDate, cutoffAt time.Time, orders []DietOrder, censusAt time.Time,
	by string, now time.Time) (MealCensus, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return MealCensus{}, fmt.Errorf("%w: a census needs an id",
			ErrInvalidDietetics)
	case !knownCycle[cycle]:
		return MealCensus{}, fmt.Errorf("%w: unknown meal cycle %q",
			ErrInvalidDietetics, cycle)
	case strings.TrimSpace(wardID) == "":
		return MealCensus{}, fmt.Errorf("%w: a census names its ward",
			ErrInvalidDietetics)
	case serviceDate.IsZero():
		return MealCensus{}, fmt.Errorf("%w: a census names its service date",
			ErrInvalidDietetics)
	case cutoffAt.IsZero():
		// SRS-DIET-005's acceptance turns on the cutoff. A census with none
		// never freezes, and a census that never freezes is a count nobody
		// can be held to.
		return MealCensus{}, fmt.Errorf(
			"%w: a census names the production cutoff", ErrInvalidDietetics)
	}

	byPatient := map[string][]DietOrder{}
	for _, order := range orders {
		if order.WardID != "" && !strings.EqualFold(order.WardID, wardID) {
			continue
		}
		byPatient[order.PatientID] = append(byPatient[order.PatientID], order)
	}

	lines := make([]CensusLine, 0, len(byPatient))
	for _, patientOrders := range byPatient {
		order, found := OrderInForce(patientOrders, censusAt)
		if !found || !order.Route.Oral() {
			continue
		}
		lines = append(lines, CensusLine{
			PatientID: order.PatientID, EncounterID: order.EncounterID,
			WardID: order.WardID, BedID: order.BedID,
			OrderID: order.ID, Route: order.Route,
			TextureCode:  order.Texture.Code,
			TextureLabel: order.Texture.Label,
			FluidCode:    order.Texture.FluidCode,
			Restrictions: order.Restrictions,
			Supplements:  order.Supplements,
			Instruction:  order.Instruction,
		})
	}
	sort.Slice(lines, func(a, b int) bool {
		if lines[a].BedID != lines[b].BedID {
			return lines[a].BedID < lines[b].BedID
		}
		return lines[a].PatientID < lines[b].PatientID
	})

	return MealCensus{
		ID: id, TenantID: tenantID, FacilityID: facilityID, WardID: wardID,
		Cycle: cycle, ServiceDate: serviceDate.UTC(),
		CutoffAt: cutoffAt.UTC(), Lines: lines,
		State: CensusDraft, Version: 1,
		BuiltAt: now.UTC(), BuiltBy: by,
	}, nil
}

// Freeze fixes the census at production cutoff (SRS-DIET-005).
func (c *MealCensus) Freeze(by string, now time.Time) error {
	switch {
	case c.State != CensusDraft:
		return fmt.Errorf("%w: this census is already %s",
			ErrInvalidDietetics, c.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a freeze names who made it",
			ErrInvalidDietetics)
	}
	c.State = CensusFrozen
	c.FrozenAt, c.FrozenBy = now.UTC(), by
	return nil
}

// Reissue builds the next version of a frozen census (SRS-DIET-005).
//
// A new census rather than an edit, and the frozen one stays readable. A ward
// that admits four patients after cutoff gets four more trays, and the
// hospital keeps both answers to "what did the kitchen cook to": the one at
// cutoff and the one it actually sent.
func (c MealCensus) Reissue(id string, orders []DietOrder, at time.Time,
	by string, now time.Time) (MealCensus, error) {

	if c.State == CensusDraft {
		return MealCensus{}, fmt.Errorf(
			"%w: this census has not been frozen; change it instead",
			ErrInvalidDietetics)
	}
	next, err := BuildCensus(id, c.TenantID, c.FacilityID, c.WardID, c.Cycle,
		c.ServiceDate, c.CutoffAt, orders, at, by, now)
	if err != nil {
		return MealCensus{}, err
	}
	next.Version = c.Version + 1
	next.SupersedesID = c.ID
	return next, nil
}

// TrayState is where one patient's tray stands (SRS-DIET-006).
type TrayState string

const (
	TrayPlanned    TrayState = "planned"
	TrayPrepared   TrayState = "prepared"
	TrayDispatched TrayState = "dispatched"
	TrayDelivered  TrayState = "delivered"
	// TrayRefused is a patient who was offered the meal and declined it.
	TrayRefused TrayState = "refused"
	// TrayMissed is a meal that never reached the patient. A clinical fact
	// rather than a logistics one: a patient who missed three meals is a
	// patient who has not eaten for a day.
	TrayMissed TrayState = "missed"
	// TrayWithheld is a tray the dispatch check stopped. The reason is
	// required, because the common one is that the patient is now nil by
	// mouth and somebody needs to know the meal did not simply go astray.
	TrayWithheld TrayState = "withheld"
)

// Tray is one patient's meal through preparation and delivery
// (SRS-DIET-006).
type Tray struct {
	ID       string
	TenantID string

	CensusID  string
	PatientID string
	WardID    string
	BedID     string
	Cycle     MealCycle
	// OrderID is the order the tray was plated to, from the census line.
	OrderID string

	State  TrayState
	Reason string

	PreparedAt   time.Time
	PreparedBy   string
	DispatchedAt time.Time
	DispatchedBy string
	DeliveredAt  time.Time
	DeliveredBy  string
	// DueBy is when the meal stops being this meal. A lunch delivered at
	// seven in the evening is a missed lunch and a late dinner.
	DueBy time.Time

	Version int64
}

// NewTray plates one census line (SRS-DIET-006).
func NewTray(id, tenantID string, census MealCensus, line CensusLine,
	dueBy time.Time) (Tray, error) {

	if strings.TrimSpace(id) == "" {
		return Tray{}, fmt.Errorf("%w: a tray needs an id",
			ErrInvalidDietetics)
	}
	if census.State == CensusDraft {
		// Cooking to a census that has not been frozen is cooking to a
		// number that is still moving.
		return Tray{}, fmt.Errorf(
			"%w: this census has not been frozen at its cutoff",
			ErrInvalidDietetics)
	}
	return Tray{
		ID: id, TenantID: tenantID, CensusID: census.ID,
		PatientID: line.PatientID, WardID: line.WardID, BedID: line.BedID,
		Cycle: census.Cycle, OrderID: line.OrderID,
		State: TrayPlanned, DueBy: utcOrZero(dueBy), Version: 1,
	}, nil
}

// Prepare records the tray plated (SRS-DIET-006).
func (t *Tray) Prepare(by string, now time.Time) error {
	if t.State != TrayPlanned {
		return fmt.Errorf("%w: this tray is %s", ErrInvalidDietetics, t.State)
	}
	t.State = TrayPrepared
	t.PreparedAt, t.PreparedBy = now.UTC(), by
	return nil
}

// Dispatch sends the tray to the ward, against the order in force now
// (SRS-DIET-009).
//
// The load-bearing rule of this whole context. The census was taken before
// the cutoff and the tray leaves the kitchen afterwards, and in between is
// exactly where a patient is made nil by mouth for a theatre list, downgraded
// to a pureed texture after a swallow assessment, or discharged. A kitchen
// that dispatches what the census said is a kitchen that sends breakfast to a
// patient who is about to be anaesthetised.
//
// So the order is re-read here and the tray is refused when it no longer
// matches: not found, no longer oral, or a texture or restriction that has
// changed. The caller records the refusal with Withhold, which is why the
// reason is in the error.
func (t *Tray) Dispatch(inForce DietOrder, found bool, line CensusLine,
	by string, now time.Time) error {

	if t.State != TrayPrepared {
		return fmt.Errorf("%w: this tray is %s and has not been prepared",
			ErrInvalidDietetics, t.State)
	}
	if reason, stop := WithholdReason(inForce, found, line); stop {
		return fmt.Errorf("%w: %s", ErrInvalidDietetics, reason)
	}

	t.State = TrayDispatched
	t.DispatchedAt, t.DispatchedBy = now.UTC(), by
	return nil
}

// WithholdReason says why a plated tray must not leave the kitchen
// (SRS-DIET-009).
//
// Separated from Dispatch so a worklist can show the ward what is being held
// back and why before anybody walks up there with it.
func WithholdReason(inForce DietOrder, found bool, line CensusLine) (
	string, bool) {

	switch {
	case !found:
		return "no diet order is in force for this patient", true
	case inForce.Route == RouteNPO:
		return "the patient is nil by mouth", true
	case !inForce.Route.Oral():
		return "the patient is now fed by the " + string(inForce.Route) +
			" route", true
	case !strings.EqualFold(inForce.Texture.Code, line.TextureCode):
		return "the texture changed to " + inForce.Texture.Code +
			" after this tray was plated", true
	case !strings.EqualFold(inForce.Texture.FluidCode, line.FluidCode):
		return "the fluid level changed to " + inForce.Texture.FluidCode +
			" after this tray was plated", true
	case !sameSet(inForce.Restrictions, line.Restrictions):
		return "the therapeutic restrictions changed after this tray was " +
			"plated", true
	}
	return "", false
}

// Withhold records a tray the dispatch check stopped (SRS-DIET-009).
func (t *Tray) Withhold(reason, by string, now time.Time) error {
	switch {
	case t.State == TrayDelivered || t.State == TrayWithheld:
		return fmt.Errorf("%w: this tray is %s", ErrInvalidDietetics, t.State)
	case strings.TrimSpace(reason) == "":
		// The common reason is that the patient is now nil by mouth, and the
		// ward needs to know the meal did not simply go astray.
		return fmt.Errorf("%w: say why the tray is being held back",
			ErrInvalidDietetics)
	}
	t.State = TrayWithheld
	t.Reason = strings.TrimSpace(reason)
	_ = by
	_ = now
	return nil
}

// Deliver records the meal reaching the patient (SRS-DIET-006).
func (t *Tray) Deliver(by string, now time.Time) error {
	if t.State != TrayDispatched {
		return fmt.Errorf("%w: this tray is %s and was not dispatched",
			ErrInvalidDietetics, t.State)
	}
	t.State = TrayDelivered
	t.DeliveredAt, t.DeliveredBy = now.UTC(), by
	return nil
}

// Close records a meal that did not reach the patient, or that they declined
// (SRS-DIET-006).
func (t *Tray) Close(to TrayState, reason, by string, now time.Time) error {
	switch {
	case to != TrayRefused && to != TrayMissed:
		return fmt.Errorf("%w: a tray closes as refused or missed, not %q",
			ErrInvalidDietetics, to)
	case t.State == TrayDelivered || t.State == TrayRefused ||
		t.State == TrayMissed || t.State == TrayWithheld:
		return fmt.Errorf("%w: this tray is already %s",
			ErrInvalidDietetics, t.State)
	case strings.TrimSpace(reason) == "":
		// A patient who has not eaten needs a reason recorded, because three
		// of these in a row is a referral rather than a logistics note.
		return fmt.Errorf("%w: say why the meal was not eaten",
			ErrInvalidDietetics)
	}
	t.State = to
	t.Reason = strings.TrimSpace(reason)
	t.DeliveredBy = by
	t.DeliveredAt = now.UTC()
	return nil
}

// MealOutcome counts a service (SRS-DIET-006).
type MealOutcome struct {
	Planned   int
	Delivered int
	Refused   int
	Missed    int
	Withheld  int
	// Late counts meals delivered after their own due time. Counted apart
	// from missed, because a lunch at four is a different failure from a
	// lunch that never came.
	Late int
	// Outstanding is trays still in flight at the moment asked about.
	Outstanding int
}

// SummariseMeals counts what happened to a service's trays (SRS-DIET-006).
func SummariseMeals(trays []Tray, at time.Time) MealOutcome {
	out := MealOutcome{}
	for _, tray := range trays {
		out.Planned++
		switch tray.State {
		case TrayDelivered:
			out.Delivered++
			if !tray.DueBy.IsZero() && tray.DeliveredAt.After(tray.DueBy) {
				out.Late++
			}
		case TrayRefused:
			out.Refused++
		case TrayMissed:
			out.Missed++
		case TrayWithheld:
			out.Withheld++
		default:
			out.Outstanding++
			if !tray.DueBy.IsZero() && at.After(tray.DueBy) {
				// Still in the kitchen past the time the meal stops being
				// this meal. Counted late now rather than at the end of the
				// day, because a ward can still do something about it.
				out.Late++
			}
		}
	}
	return out
}

func sameSet(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	seen := map[string]int{}
	for _, value := range a {
		seen[strings.ToLower(strings.TrimSpace(value))]++
	}
	for _, value := range b {
		key := strings.ToLower(strings.TrimSpace(value))
		seen[key]--
		if seen[key] < 0 {
			return false
		}
	}
	return true
}
