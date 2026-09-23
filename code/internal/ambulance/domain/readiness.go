package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Readiness checks (SRS-AMB-006).
//
// SRS-AMB-006's acceptance is that a missing critical readiness item blocks
// the ready state or requires an override. Both halves are here: a check with
// a failed critical item does not pass, and an override is a named person, a
// reason, and a notice that goes out — because an ambulance sent without
// oxygen is a decision somebody has to be able to point at afterwards.
//
// The oxygen level is a number rather than a tick, because "oxygen present"
// is true of a cylinder with forty bar left in it and that cylinder will not
// finish a long transfer.

// ReadinessItem is one thing checked before a shift or a trip
// (SRS-AMB-006).
type ReadinessItem struct {
	Code  string
	Label string
	// Critical marks an item the vehicle cannot run without. A failed
	// critical item blocks the ready state; a failed ordinary one is
	// recorded and does not.
	Critical bool
}

// ItemOutcome is one item's result.
type ItemOutcome struct {
	Code    string
	Present bool
	// Note is why an item is absent, or anything the checker wants beside
	// it. Required when the item is not present: a missing item with no
	// note is indistinguishable from one nobody looked for.
	Note string
}

// CheckState is where a readiness check stands (SRS-AMB-006).
type CheckState string

const (
	// CheckPassed is every critical item present.
	CheckPassed CheckState = "passed"
	// CheckFailed is a critical item missing and nobody overriding it. The
	// vehicle does not go on the run.
	CheckFailed CheckState = "failed"
	// CheckOverridden is a critical item missing and somebody sending the
	// vehicle anyway, by name and reason. Its own state, so a readiness
	// report cannot count it as a pass.
	CheckOverridden CheckState = "overridden"
)

// ReadinessCheck is a vehicle checked before it goes on the run
// (SRS-AMB-006).
type ReadinessCheck struct {
	ID       string
	TenantID string

	VehicleID  string
	ShiftID    string
	FacilityID string

	// Items are the standard's items, copied at check time so a standard
	// edited afterwards does not change what this check was judged against.
	Items    []ReadinessItem
	Outcomes []ItemOutcome

	// OxygenBar is the main cylinder's pressure. Zero means nobody read it,
	// which is reported rather than treated as empty.
	OxygenBar int
	// OxygenMinimumBar is the level below which the vehicle is not ready.
	OxygenMinimumBar int

	State CheckState
	// Missing lists the critical items that failed, so a dispatcher looking
	// at an overridden vehicle can see what it is going without.
	Missing []string

	OverrideBy     string
	OverrideReason string
	OverrideAt     time.Time

	// ValidUntil is when the check lapses. A vehicle whose check has
	// expired is not ready without anybody changing its state.
	ValidUntil time.Time

	CheckedAt time.Time
	CheckedBy string
	Version   int64
}

// Passed reports a check that puts a vehicle on the run without an override
// (SRS-AMB-006).
func (c ReadinessCheck) Passed() bool {
	return c.State == CheckPassed || c.State == CheckOverridden
}

// NewCheckInput records a readiness check.
type NewCheckInput struct {
	VehicleID        string
	ShiftID          string
	FacilityID       string
	Items            []ReadinessItem
	Outcomes         []ItemOutcome
	OxygenBar        int
	OxygenMinimumBar int
	ValidFor         time.Duration
}

// RecordCheck records a vehicle being checked (SRS-AMB-006).
//
// The state is derived from the outcomes rather than supplied. A check whose
// result the checker could type is a check whose result the checker types.
func RecordCheck(id, tenantID string, in NewCheckInput, by string,
	now time.Time) (ReadinessCheck, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ReadinessCheck{}, fmt.Errorf("%w: a check needs an id",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.VehicleID) == "":
		return ReadinessCheck{}, fmt.Errorf("%w: a check names its vehicle",
			ErrInvalidAmbulance)
	case strings.TrimSpace(by) == "":
		return ReadinessCheck{}, fmt.Errorf(
			"%w: a check names who made it", ErrInvalidAmbulance)
	case len(in.Items) == 0:
		// A check with no items is a vehicle that passes by having nothing
		// asked of it.
		return ReadinessCheck{}, fmt.Errorf(
			"%w: a check says what was checked", ErrInvalidAmbulance)
	case in.OxygenBar < 0 || in.OxygenMinimumBar < 0:
		return ReadinessCheck{}, fmt.Errorf(
			"%w: a pressure cannot be negative", ErrInvalidAmbulance)
	case in.ValidFor <= 0:
		// A check that never lapses is a vehicle checked once in March.
		return ReadinessCheck{}, fmt.Errorf(
			"%w: a check says how long it holds for", ErrInvalidAmbulance)
	}

	items := make([]ReadinessItem, 0, len(in.Items))
	seen := map[string]bool{}
	for _, item := range in.Items {
		code := strings.TrimSpace(item.Code)
		switch {
		case code == "":
			return ReadinessCheck{}, fmt.Errorf(
				"%w: a checklist item needs a code", ErrInvalidAmbulance)
		case seen[strings.ToLower(code)]:
			return ReadinessCheck{}, fmt.Errorf(
				"%w: checklist item %q appears twice",
				ErrInvalidAmbulance, code)
		}
		seen[strings.ToLower(code)] = true
		items = append(items, ReadinessItem{
			Code: code, Label: strings.TrimSpace(item.Label),
			Critical: item.Critical,
		})
	}

	given := map[string]ItemOutcome{}
	for _, outcome := range in.Outcomes {
		code := strings.TrimSpace(outcome.Code)
		if code == "" {
			return ReadinessCheck{}, fmt.Errorf(
				"%w: an outcome names its checklist item",
				ErrInvalidAmbulance)
		}
		if !outcome.Present && strings.TrimSpace(outcome.Note) == "" {
			// A missing item with no note is indistinguishable from one
			// nobody looked for.
			return ReadinessCheck{}, fmt.Errorf(
				"%w: say why %q is missing", ErrInvalidAmbulance, code)
		}
		given[strings.ToLower(code)] = ItemOutcome{
			Code: code, Present: outcome.Present,
			Note: strings.TrimSpace(outcome.Note),
		}
	}

	ordered := make([]ItemOutcome, 0, len(items))
	var missing []string
	for _, item := range items {
		outcome, answered := given[strings.ToLower(item.Code)]
		if !answered {
			// An item nobody answered is not a pass. A checklist half
			// filled in is the one a coroner reads.
			return ReadinessCheck{}, fmt.Errorf(
				"%w: %q has not been checked", ErrInvalidAmbulance,
				item.Code)
		}
		ordered = append(ordered, outcome)
		if item.Critical && !outcome.Present {
			missing = append(missing, item.Code)
		}
	}

	// Oxygen is a level rather than a tick: "present" is true of a cylinder
	// with forty bar left in it, and that cylinder will not finish a long
	// transfer.
	if in.OxygenMinimumBar > 0 && in.OxygenBar < in.OxygenMinimumBar {
		missing = append(missing, "oxygen")
	}
	sort.Strings(missing)

	state := CheckPassed
	if len(missing) > 0 {
		state = CheckFailed
	}

	return ReadinessCheck{
		ID: id, TenantID: tenantID,
		VehicleID:  strings.TrimSpace(in.VehicleID),
		ShiftID:    strings.TrimSpace(in.ShiftID),
		FacilityID: in.FacilityID,
		Items:      items, Outcomes: ordered,
		OxygenBar: in.OxygenBar, OxygenMinimumBar: in.OxygenMinimumBar,
		State: state, Missing: missing,
		ValidUntil: now.Add(in.ValidFor).UTC(),
		CheckedAt:  now.UTC(), CheckedBy: by, Version: 1,
	}, nil
}

// Override sends a vehicle out despite a failed critical item
// (SRS-AMB-006).
//
// Refused for the person who made the check. Somebody who found the oxygen
// empty and then waved it through is one person deciding both, and the
// requirement's "or requires override" means a second pair of eyes rather
// than a second click.
func (c *ReadinessCheck) Override(reason, by string, now time.Time) error {
	switch {
	case c.State != CheckFailed:
		return fmt.Errorf("%w: this check is %s; there is nothing to "+
			"override", ErrInvalidAmbulance, c.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an override names who made it",
			ErrInvalidAmbulance)
	case by == c.CheckedBy:
		return fmt.Errorf(
			"%w: an override is made by somebody other than whoever "+
				"checked the vehicle", ErrInvalidAmbulance)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf(
			"%w: say why the vehicle is going out without %s",
			ErrInvalidAmbulance, strings.Join(c.Missing, ", "))
	}

	c.State = CheckOverridden
	c.OverrideBy, c.OverrideAt = by, now.UTC()
	c.OverrideReason = strings.TrimSpace(reason)
	return nil
}

// ReadinessSummary reports how a fleet's checks went (SRS-AMB-006,
// SRS-AMB-008).
type ReadinessSummary struct {
	Checked int
	Passed  int
	Failed  int
	// Overridden is counted apart from passed and never folded in, because
	// a fleet where every check is overridden reads as a fleet that passes
	// every check.
	Overridden int
	// MissingByItem counts which critical items were the ones missing,
	// which is the number that tells a service what to buy.
	MissingByItem map[string]int
	// Unanswerable is a set with no checks in it.
	Unanswerable bool
}

// SummariseReadiness counts a set of checks (SRS-AMB-006).
func SummariseReadiness(checks []ReadinessCheck) ReadinessSummary {
	out := ReadinessSummary{MissingByItem: map[string]int{}}
	for _, check := range checks {
		out.Checked++
		switch check.State {
		case CheckPassed:
			out.Passed++
		case CheckFailed:
			out.Failed++
		case CheckOverridden:
			out.Overridden++
		}
		for _, item := range check.Missing {
			out.MissingByItem[item]++
		}
	}
	if out.Checked == 0 {
		out.Unanswerable = true
	}
	return out
}
