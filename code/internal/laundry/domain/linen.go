// Package domain holds the laundry and linen rules (SRS-LND-001 … 007).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
//
// Two properties run through the package and are worth stating once.
//
// Linen from a batch that did not pass is never issued to a ward. A wash that
// failed its cycle — the temperature never held, the machine aborted, the
// disinfection stage was skipped — produces linen that looks exactly like
// clean linen and is not, and the ward it reaches cannot tell by looking.
// SRS-LND-003's acceptance is that the batch outcome and its exceptions are
// recorded; the reason to record them is that the issue reads them, so
// `IssueLinen` refuses a batch that is not passed and the database refuses
// the row.
//
// And infected linen is declared at source and never opened again. The unit
// that generated it counts it, bags it and seals the bag; the laundry weighs
// the bag and puts it through a barrier cycle. There is no function here that
// re-counts a sealed infected collection and no path that puts one into an
// ordinary wash, because both of those are somebody in a sorting room with
// their hands in it. SRS-LND-005 asks that the worklist visibly identify the
// required handling, and what makes that true is that the handling is a
// property of the collection rather than a note somebody adds.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidLaundry reports a refused laundry action.
var ErrInvalidLaundry = errors.New("laundry: invalid")

// Category groups linen for par levels and reporting (SRS-LND-001).
type Category string

const (
	// CategoryBedding is sheets, pillowcases, blankets and draw sheets.
	CategoryBedding Category = "bedding"
	// CategoryPatient is gowns, pyjamas and towels.
	CategoryPatient Category = "patient"
	// CategoryTheatre is drapes, gowns and wraps. Kept apart because a
	// theatre item that failed its wash is a different conversation.
	CategoryTheatre Category = "theatre"
	// CategoryUniform is staff uniforms and scrubs, which is where the
	// high-value tracked items mostly are.
	CategoryUniform Category = "uniform"
	// CategoryOther is curtains, mop heads and everything else.
	CategoryOther Category = "other"
)

var knownCategory = map[Category]bool{
	CategoryBedding: true, CategoryPatient: true, CategoryTheatre: true,
	CategoryUniform: true, CategoryOther: true,
}

// LinenItem is one thing the hospital launders (SRS-LND-001).
type LinenItem struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Category Category

	// UnitWeightG is the dry weight of one piece, used to reconcile a
	// declared count against a weighed bag. Zero means the hospital has not
	// weighed one, and the reconciliation is then reported as unanswerable
	// rather than as a discrepancy of everything.
	UnitWeightG int
	// ReplacementCostMinor is what one costs, in the tenant's minor units.
	// Integers: a linen budget in rupees and paise is not a floating-point
	// problem.
	ReplacementCostMinor int
	// Tracked marks an item carrying an RFID or barcode tag
	// (SRS-LND-007). High-value linen and uniforms, where "where is it" is
	// a question somebody actually asks.
	Tracked bool

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewItemInput configures a linen item.
type NewItemInput struct {
	Code                 string
	Name                 string
	Category             Category
	UnitWeightG          int
	ReplacementCostMinor int
	Tracked              bool
}

// NewItem registers a linen item (SRS-LND-001).
func NewItem(id, tenantID string, in NewItemInput, by string,
	now time.Time) (LinenItem, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return LinenItem{}, fmt.Errorf("%w: a linen item needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.Code) == "":
		return LinenItem{}, fmt.Errorf("%w: a linen item needs a code",
			ErrInvalidLaundry)
	case !knownCategory[in.Category]:
		return LinenItem{}, fmt.Errorf("%w: unknown linen category %q",
			ErrInvalidLaundry, in.Category)
	case in.UnitWeightG < 0 || in.ReplacementCostMinor < 0:
		return LinenItem{}, fmt.Errorf(
			"%w: a weight or a cost cannot be negative", ErrInvalidLaundry)
	}

	return LinenItem{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Category:             in.Category,
		UnitWeightG:          in.UnitWeightG,
		ReplacementCostMinor: in.ReplacementCostMinor,
		Tracked:              in.Tracked,
		Active:               true,
		CreatedAt:            now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Retire stops an item being issued without deleting what was
// (SRS-LND-001).
func (l *LinenItem) Retire(now time.Time) error {
	if !l.Active {
		return fmt.Errorf("%w: this item is already retired",
			ErrInvalidLaundry)
	}
	l.Active = false
	_ = now
	return nil
}

// ParLine is one item's par level for one unit (SRS-LND-001).
type ParLine struct {
	ItemCode string
	// Quantity is the number of pieces the unit should hold.
	Quantity int
	// ReorderAt is the level at which a top-up is raised. Zero means top up
	// whenever the unit is below par, which is the ordinary case.
	ReorderAt int
}

// ParLevel is a unit's linen holding, effective-dated (SRS-LND-001).
//
// Versioned by (unit, revision) and effective-dated, because SRS-LND-001's
// acceptance says so in as many words. A par edited in place would change
// what last month's shortfall was measured against, and the question after a
// ward ran out of sheets is always what the par said at the time.
type ParLevel struct {
	ID       string
	TenantID string

	// UnitID is the ward, theatre suite or department the par belongs to.
	UnitID     string
	UnitName   string
	FacilityID string
	Revision   int

	Lines []ParLine

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Live reports a par level in force at a moment (SRS-LND-001).
func (p ParLevel) Live(at time.Time) bool {
	if !p.Approved || p.EffectiveFrom.IsZero() {
		return false
	}
	if at.Before(p.EffectiveFrom) {
		return false
	}
	return p.SupersededAt.IsZero() || at.Before(p.SupersededAt)
}

// NewParInput configures a unit's par level.
type NewParInput struct {
	UnitID        string
	UnitName      string
	FacilityID    string
	Revision      int
	Lines         []ParLine
	EffectiveFrom time.Time
}

// NewParLevel drafts a unit's linen par (SRS-LND-001).
func NewParLevel(id, tenantID string, in NewParInput, by string,
	now time.Time) (ParLevel, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ParLevel{}, fmt.Errorf("%w: a par level needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.UnitID) == "":
		return ParLevel{}, fmt.Errorf("%w: a par level names its unit",
			ErrInvalidLaundry)
	case in.Revision <= 0:
		return ParLevel{}, fmt.Errorf(
			"%w: a par revision starts at one", ErrInvalidLaundry)
	case len(in.Lines) == 0:
		// A par with no lines is a unit whose shortfall is always zero,
		// which reads as a ward that never runs out.
		return ParLevel{}, fmt.Errorf(
			"%w: a par level says what the unit should hold",
			ErrInvalidLaundry)
	}

	lines := make([]ParLine, 0, len(in.Lines))
	seen := map[string]bool{}
	for _, line := range in.Lines {
		code := strings.TrimSpace(line.ItemCode)
		switch {
		case code == "":
			return ParLevel{}, fmt.Errorf("%w: a par line names its item",
				ErrInvalidLaundry)
		case seen[strings.ToLower(code)]:
			// The same item twice is two pars for one thing, and a
			// shortfall that counts whichever the reader reached first.
			return ParLevel{}, fmt.Errorf("%w: item %q appears twice",
				ErrInvalidLaundry, code)
		case line.Quantity <= 0:
			return ParLevel{}, fmt.Errorf(
				"%w: the par for %q is not a positive number",
				ErrInvalidLaundry, code)
		case line.ReorderAt < 0 || line.ReorderAt > line.Quantity:
			return ParLevel{}, fmt.Errorf(
				"%w: the reorder level for %q is not between zero and par",
				ErrInvalidLaundry, code)
		}
		seen[strings.ToLower(code)] = true
		lines = append(lines, ParLine{
			ItemCode: code, Quantity: line.Quantity,
			ReorderAt: line.ReorderAt,
		})
	}

	return ParLevel{
		ID: id, TenantID: tenantID,
		UnitID:     strings.TrimSpace(in.UnitID),
		UnitName:   strings.TrimSpace(in.UnitName),
		FacilityID: in.FacilityID, Revision: in.Revision,
		Lines:         lines,
		EffectiveFrom: utcOrZero(in.EffectiveFrom),
		CreatedAt:     now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Approve puts a par level in force (SRS-LND-001).
//
// Refused for the author. A par decides how much linen a ward is entitled to
// hold and therefore what the laundry buys, and one person writing and
// approving it is one person deciding that.
func (p *ParLevel) Approve(by string, effectiveFrom, now time.Time) error {
	switch {
	case p.Approved:
		return fmt.Errorf("%w: this par level is already approved",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who made it",
			ErrInvalidLaundry)
	case by == p.CreatedBy:
		return fmt.Errorf("%w: the author of a par level cannot approve it",
			ErrInvalidLaundry)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved par level says when it takes "+
			"effect", ErrInvalidLaundry)
	}

	p.Approved = true
	p.ApprovedBy, p.ApprovedAt = by, now.UTC()
	p.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// ParInForce picks the par level a unit is held to (SRS-LND-001).
//
// The latest effective revision in force. One, never a list: two live pars
// for one ward is a ward stocked to whichever the reader opened.
func ParInForce(levels []ParLevel, unitID string, at time.Time) (ParLevel,
	bool) {

	var best ParLevel
	found := false
	for _, level := range levels {
		if !strings.EqualFold(level.UnitID, unitID) || !level.Live(at) {
			continue
		}
		if !found || level.EffectiveFrom.After(best.EffectiveFrom) ||
			(level.EffectiveFrom.Equal(best.EffectiveFrom) &&
				level.Revision > best.Revision) {
			best, found = level, true
		}
	}
	return best, found
}

// Shortfall is one item a unit is below par on (SRS-LND-001, SRS-LND-004).
type Shortfall struct {
	ItemCode string
	Par      int
	OnHand   int
	Short    int
}

// Shortfalls lists what a unit is missing against the par in force
// (SRS-LND-001, SRS-LND-004).
//
// Derived from the par and the balance rather than stored, which is what
// makes a par changed this morning produce the right top-up this afternoon.
// An item at or above par is absent from the list rather than present with a
// zero, because a top-up sheet listing every item the ward already has is one
// nobody reads to the end.
func Shortfalls(par ParLevel, onHand map[string]int) []Shortfall {
	var out []Shortfall
	for _, line := range par.Lines {
		held := onHand[line.ItemCode]
		// With a reorder level, the ward is topped up once it falls to it.
		// Without one, once it falls below par. An item sitting exactly at
		// par is not short, and treating it as short would put every item
		// the ward already has on the sheet.
		short := held < line.Quantity
		if line.ReorderAt > 0 {
			short = held <= line.ReorderAt
		}
		if !short {
			continue
		}
		out = append(out, Shortfall{
			ItemCode: line.ItemCode, Par: line.Quantity,
			OnHand: held, Short: line.Quantity - held,
		})
	}
	sort.Slice(out, func(a, b int) bool {
		// Deepest shortfall first. A list in item-code order sends a porter
		// with two pillowcases while the ward has no sheets.
		if out[a].Short != out[b].Short {
			return out[a].Short > out[b].Short
		}
		return out[a].ItemCode < out[b].ItemCode
	})
	return out
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}
