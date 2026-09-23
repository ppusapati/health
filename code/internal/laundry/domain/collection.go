package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// SoilClass is how a bag of linen has to be handled (SRS-LND-002,
// SRS-LND-005).
//
// An enum rather than a flag, because "infected" is not a degree of "soiled".
// It decides which bag the linen goes into at the bedside, whether anybody may
// open it again, and which wash cycle it is allowed into. A boolean beside a
// free-text note would be a field somebody leaves at its default.
type SoilClass string

const (
	// SoilUsed is linen that was on a bed and is not wet.
	SoilUsed SoilClass = "used"
	// SoilFouled is linen with blood or body fluid on it. Handled with
	// gloves and washed hot; not a barrier load.
	SoilFouled SoilClass = "fouled"
	// SoilInfected is linen from a patient on transmission-based
	// precautions. Bagged at the bedside in a water-soluble inner bag,
	// sealed, never opened again, and washed in a barrier cycle.
	SoilInfected SoilClass = "infected"
)

var knownSoilClass = map[SoilClass]bool{
	SoilUsed: true, SoilFouled: true, SoilInfected: true,
}

// Sealed reports the classes nobody may open, sort or re-count
// (SRS-LND-005).
func (s SoilClass) Sealed() bool { return s == SoilInfected }

// Handling is the instruction a worklist has to show for this class
// (SRS-LND-005).
//
// Derived from the class rather than typed beside it, so a worklist cannot
// show one thing and the wash cycle enforce another.
func (s SoilClass) Handling() string {
	switch s {
	case SoilInfected:
		return "barrier: do not open or sort; water-soluble bag into a " +
			"barrier cycle"
	case SoilFouled:
		return "gloves and apron; hot wash"
	default:
		return "standard handling"
	}
}

// CollectionLine is one item's declared count in a collection.
type CollectionLine struct {
	ItemCode string
	// Quantity is what the source unit counted. For a sealed class it is a
	// declaration and stays one: the laundry never checks it by opening the
	// bag.
	Quantity int
}

// CollectionState is where a soiled collection stands (SRS-LND-002).
type CollectionState string

const (
	// CollectionOpen is recorded at the unit and not yet in a batch.
	CollectionOpen CollectionState = "open"
	// CollectionBatched is in a wash batch. The chain SRS-LND-002 asks to
	// be retained is this link.
	CollectionBatched CollectionState = "batched"
	// CollectionCancelled is a collection recorded in error. Kept, because
	// a unit's linen loss is computed from what went out and what came
	// back, and a deleted collection reads as linen the ward never returned.
	CollectionCancelled CollectionState = "cancelled"
)

// Collection is soiled linen taken from one unit (SRS-LND-002).
type Collection struct {
	ID       string
	TenantID string

	UnitID     string
	UnitName   string
	FacilityID string

	SoilClass SoilClass
	// Handling is copied from the class at collection time, so the worklist
	// a porter reads and the cycle the machine runs cannot disagree
	// (SRS-LND-005).
	Handling string
	// BagCount is how many sealed bags came over. The unit of work for an
	// infected collection, where there is no other honest count.
	BagCount int
	// WeightG is what the bags weighed. The laundry's own number, taken
	// without opening anything.
	WeightG int

	// Lines are the source unit's declared counts. Empty is allowed and
	// ordinary for a sealed class recorded by bag and weight alone.
	Lines []CollectionLine

	State CollectionState
	// BatchID is the wash batch this went into.
	BatchID string

	CancelReason string

	CollectedAt time.Time
	CollectedBy string
	Version     int64
}

// NewCollectionInput records soiled linen leaving a unit.
type NewCollectionInput struct {
	UnitID     string
	UnitName   string
	FacilityID string
	SoilClass  SoilClass
	BagCount   int
	WeightG    int
	Lines      []CollectionLine
}

// RecordCollection records soiled linen taken from a unit (SRS-LND-002).
func RecordCollection(id, tenantID string, in NewCollectionInput, by string,
	now time.Time) (Collection, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Collection{}, fmt.Errorf("%w: a collection needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.UnitID) == "":
		return Collection{}, fmt.Errorf("%w: a collection names its unit",
			ErrInvalidLaundry)
	case !knownSoilClass[in.SoilClass]:
		// A collection whose class nobody set would be handled as ordinary
		// linen, which is the outcome SRS-LND-005 exists to prevent.
		return Collection{}, fmt.Errorf("%w: unknown soil class %q",
			ErrInvalidLaundry, in.SoilClass)
	case strings.TrimSpace(by) == "":
		return Collection{}, fmt.Errorf(
			"%w: a collection names who took it", ErrInvalidLaundry)
	case in.BagCount <= 0:
		return Collection{}, fmt.Errorf(
			"%w: a collection is at least one bag", ErrInvalidLaundry)
	case in.WeightG < 0:
		return Collection{}, fmt.Errorf("%w: a weight cannot be negative",
			ErrInvalidLaundry)
	}

	lines := make([]CollectionLine, 0, len(in.Lines))
	seen := map[string]bool{}
	for _, line := range in.Lines {
		code := strings.TrimSpace(line.ItemCode)
		switch {
		case code == "":
			return Collection{}, fmt.Errorf(
				"%w: a collection line names its item", ErrInvalidLaundry)
		case seen[strings.ToLower(code)]:
			return Collection{}, fmt.Errorf("%w: item %q appears twice",
				ErrInvalidLaundry, code)
		case line.Quantity <= 0:
			return Collection{}, fmt.Errorf(
				"%w: the count for %q is not a positive number",
				ErrInvalidLaundry, code)
		}
		seen[strings.ToLower(code)] = true
		lines = append(lines, CollectionLine{
			ItemCode: code, Quantity: line.Quantity,
		})
	}

	return Collection{
		ID: id, TenantID: tenantID,
		UnitID:     strings.TrimSpace(in.UnitID),
		UnitName:   strings.TrimSpace(in.UnitName),
		FacilityID: in.FacilityID,
		SoilClass:  in.SoilClass,
		Handling:   in.SoilClass.Handling(),
		BagCount:   in.BagCount, WeightG: in.WeightG,
		Lines: lines, State: CollectionOpen,
		CollectedAt: now.UTC(), CollectedBy: by, Version: 1,
	}, nil
}

// Cancel abandons a collection recorded in error (SRS-LND-002).
func (c *Collection) Cancel(reason, by string, now time.Time) error {
	switch {
	case c.State != CollectionOpen:
		return fmt.Errorf("%w: this collection is %s",
			ErrInvalidLaundry, c.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the collection is being cancelled",
			ErrInvalidLaundry)
	}
	c.State = CollectionCancelled
	c.CancelReason = strings.TrimSpace(reason)
	_ = by
	_ = now
	return nil
}

// Recount corrects a source unit's declared counts (SRS-LND-002).
//
// Refused for a sealed class, and that refusal is the whole of SRS-LND-005 in
// this file. Re-counting infected linen means opening the bag, and the
// declaration made at the bedside is the only count anybody is going to get.
// A system that allowed the correction would be a system where somebody was
// asked to make it.
func (c *Collection) Recount(lines []CollectionLine, by string,
	now time.Time) error {

	switch {
	case c.SoilClass.Sealed():
		return fmt.Errorf(
			"%w: infected linen is counted at the bedside and the bag is "+
				"not opened again", ErrInvalidLaundry)
	case c.State != CollectionOpen:
		return fmt.Errorf("%w: this collection is %s",
			ErrInvalidLaundry, c.State)
	case len(lines) == 0:
		return fmt.Errorf("%w: a recount says what was counted",
			ErrInvalidLaundry)
	}

	counted := make([]CollectionLine, 0, len(lines))
	seen := map[string]bool{}
	for _, line := range lines {
		code := strings.TrimSpace(line.ItemCode)
		switch {
		case code == "":
			return fmt.Errorf("%w: a collection line names its item",
				ErrInvalidLaundry)
		case seen[strings.ToLower(code)]:
			return fmt.Errorf("%w: item %q appears twice",
				ErrInvalidLaundry, code)
		case line.Quantity <= 0:
			return fmt.Errorf(
				"%w: the count for %q is not a positive number",
				ErrInvalidLaundry, code)
		}
		seen[strings.ToLower(code)] = true
		counted = append(counted, CollectionLine{
			ItemCode: code, Quantity: line.Quantity,
		})
	}

	c.Lines = counted
	_ = by
	_ = now
	return nil
}

// DeclaredPieces totals a collection's declared counts.
func (c Collection) DeclaredPieces() int {
	total := 0
	for _, line := range c.Lines {
		total += line.Quantity
	}
	return total
}

// WeightCheck compares a collection's declared count against what it weighed
// (SRS-LND-002).
//
// The one honest cross-check on a bag nobody opens: a trolley declared as
// forty sheets that weighs four kilos is not forty sheets. Reported as a
// finding rather than enforced, because linen is wet and the tolerance a
// hospital sets is a hospital's to set.
type WeightCheck struct {
	DeclaredPieces int
	ExpectedG      int
	ActualG        int
	// Unanswerable is a collection with nothing declared, or items whose
	// unit weight nobody has recorded. Reported rather than a variance of
	// everything, which would put every sealed bag on the exception list.
	Unanswerable bool
	VarianceG    int
}

// CheckWeight reconciles a collection against the item weights
// (SRS-LND-002).
func CheckWeight(c Collection, unitWeights map[string]int) WeightCheck {
	out := WeightCheck{ActualG: c.WeightG}
	if len(c.Lines) == 0 {
		out.Unanswerable = true
		return out
	}
	for _, line := range c.Lines {
		weight, known := unitWeights[line.ItemCode]
		if !known || weight <= 0 {
			out.Unanswerable = true
			return out
		}
		out.DeclaredPieces += line.Quantity
		out.ExpectedG += weight * line.Quantity
	}
	out.VarianceG = c.WeightG - out.ExpectedG
	return out
}

// PendingCollections lists what is waiting to be washed, worst first
// (SRS-LND-002, SRS-LND-005).
//
// Infected first. It is the load nobody wants sitting in a corridor, and a
// worklist in arrival order leaves it there behind a trolley of towels.
func PendingCollections(collections []Collection) []Collection {
	var out []Collection
	for _, collection := range collections {
		if collection.State == CollectionOpen {
			out = append(out, collection)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		left, right := out[a].SoilClass.Sealed(), out[b].SoilClass.Sealed()
		if left != right {
			return left
		}
		if !out[a].CollectedAt.Equal(out[b].CollectedAt) {
			return out[a].CollectedAt.Before(out[b].CollectedAt)
		}
		return out[a].ID < out[b].ID
	})
	return out
}
