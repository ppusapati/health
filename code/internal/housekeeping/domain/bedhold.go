package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// HoldState is where a bed's cleaning hold stands (SRS-HKP-003).
type HoldState string

const (
	// HoldOpen is a bed out of service until the terminal clean is done.
	HoldOpen HoldState = "open"
	// HoldReleased is a hold the clean finished.
	HoldReleased HoldState = "released"
	// HoldOverridden is a hold somebody lifted without the clean finishing.
	// Its own state rather than a released hold with a note, because the
	// two are different facts and a report that merged them would say the
	// hospital cleaned every bed.
	HoldOverridden HoldState = "overridden"
)

// BedHold keeps a bed out of service until it has been cleaned
// (SRS-HKP-003).
//
// SRS-HKP-003's acceptance is that a bed stays unavailable until the clean
// completes or somebody overrides it, and this is where that is held. The
// only ways out are the terminal clean finishing and a named override with a
// reason — and the override is a state of its own, so a hospital cannot count
// it as a clean.
//
// The hold is the authority on whether a bed is clean. Whether anything else
// consults it before allocating the bed is a property of the deployment, and
// the status document says so rather than this type pretending otherwise.
type BedHold struct {
	ID       string
	TenantID string

	BedID        string
	LocationCode string
	FacilityID   string
	Zone         string

	// TaskID is the terminal clean that must finish. Required: a hold with
	// no task behind it is a bed nobody is coming to clean.
	TaskID string
	// EncounterID is the encounter whose end raised it, where there was
	// one. Carried so a ward can see which discharge a held bed belongs to.
	EncounterID string

	State HoldState

	PlacedAt time.Time
	PlacedBy string

	ReleasedAt time.Time
	ReleasedBy string

	OverriddenAt   time.Time
	OverriddenBy   string
	OverrideReason string

	Version int64
}

// PlaceBedHold takes a bed out of service pending its terminal clean
// (SRS-HKP-003).
func PlaceBedHold(id, tenantID string, task CleaningTask, encounterID,
	by string, now time.Time) (BedHold, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return BedHold{}, fmt.Errorf("%w: a bed hold needs an id",
			ErrInvalidHousekeeping)
	case task.Kind != TaskTerminal:
		// Holding a bed for a routine clean would take every bed on the
		// ward out of service every morning.
		return BedHold{}, fmt.Errorf(
			"%w: a bed is held for a terminal clean, not a %s one",
			ErrInvalidHousekeeping, task.Kind)
	case strings.TrimSpace(task.BedID) == "":
		return BedHold{}, fmt.Errorf("%w: a bed hold names its bed",
			ErrInvalidHousekeeping)
	case strings.TrimSpace(by) == "":
		return BedHold{}, fmt.Errorf("%w: a bed hold names who placed it",
			ErrInvalidHousekeeping)
	}

	return BedHold{
		ID: id, TenantID: tenantID, BedID: task.BedID,
		LocationCode: task.LocationCode, FacilityID: task.FacilityID,
		Zone: task.Zone, TaskID: task.ID,
		EncounterID: strings.TrimSpace(encounterID),
		State:       HoldOpen,
		PlacedAt:    now.UTC(), PlacedBy: by, Version: 1,
	}, nil
}

// Release lifts a hold because the clean finished (SRS-HKP-003).
//
// The task is passed in and checked rather than trusted. A hold released
// against a task that is not done is a bed reported clean because somebody
// pressed the wrong button, and the next patient goes into it.
func (h *BedHold) Release(task CleaningTask, requireVerification bool,
	by string, now time.Time) error {

	switch {
	case h.State != HoldOpen:
		return fmt.Errorf("%w: this hold is already %s",
			ErrInvalidHousekeeping, h.State)
	case task.ID != h.TaskID:
		return fmt.Errorf(
			"%w: this hold is on task %s, not %s",
			ErrInvalidHousekeeping, h.TaskID, task.ID)
	case task.State != TaskCompleted && task.State != TaskVerified:
		return fmt.Errorf(
			"%w: the terminal clean is %s; override the hold if the bed is "+
				"needed", ErrInvalidHousekeeping, task.State)
	case requireVerification && task.State != TaskVerified:
		// Where a hospital verifies its terminal cleans, the bed comes back
		// when the supervisor says so and not when the cleaner does.
		return fmt.Errorf(
			"%w: this terminal clean has not been verified",
			ErrInvalidHousekeeping)
	}

	h.State = HoldReleased
	h.ReleasedAt, h.ReleasedBy = now.UTC(), by
	return nil
}

// Override lifts a hold without the clean finishing (SRS-HKP-003).
//
// Its own state and its own reason. This is a bed going back into service
// uncleaned, which is sometimes the right call in a full hospital and is
// always a decision somebody has to be able to point at afterwards.
func (h *BedHold) Override(reason, by string, now time.Time) error {
	switch {
	case h.State != HoldOpen:
		return fmt.Errorf("%w: this hold is already %s",
			ErrInvalidHousekeeping, h.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf(
			"%w: say why this bed is going back into service uncleaned",
			ErrInvalidHousekeeping)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an override names who made it",
			ErrInvalidHousekeeping)
	}

	h.State = HoldOverridden
	h.OverriddenAt, h.OverriddenBy = now.UTC(), by
	h.OverrideReason = strings.TrimSpace(reason)
	return nil
}

// BedClear reports whether a bed may be used (SRS-HKP-003).
//
// False while any hold on it is open. The default for an unknown bed is
// true, because this context only knows about beds somebody raised a
// terminal clean for — and a system that reported every bed in the hospital
// as dirty would be ignored within a day.
func BedClear(holds []BedHold, bedID string) bool {
	for _, hold := range holds {
		if strings.EqualFold(hold.BedID, bedID) && hold.State == HoldOpen {
			return false
		}
	}
	return true
}

// HeldBeds lists the beds out of service, longest first (SRS-HKP-003).
func HeldBeds(holds []BedHold) []BedHold {
	var out []BedHold
	for _, hold := range holds {
		if hold.State == HoldOpen {
			out = append(out, hold)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].PlacedAt.Before(out[b].PlacedAt)
	})
	return out
}
