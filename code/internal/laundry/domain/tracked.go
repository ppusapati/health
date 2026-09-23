package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Tracked linen and uniforms (SRS-LND-007).
//
// SRS-LND-007's acceptance is that a tracked item has a last known custody
// and location, and the shape that makes that true is an append-only list of
// movements with the current custody derived from the last one. A stored
// "current holder" field and a movement list disagree the first time a scan
// is recorded out of order, and the stored one is what the screen shows.
//
// A scan is evidence of where a thing was, attributed to the authenticated
// person who made it. It is not authority: nothing here writes off an item
// because it stopped being scanned, and nothing changes custody without
// naming who recorded the change.

// TagKind is how a tracked item is read.
type TagKind string

const (
	TagRFID    TagKind = "rfid"
	TagBarcode TagKind = "barcode"
)

var knownTagKind = map[TagKind]bool{TagRFID: true, TagBarcode: true}

// TrackedState is where a tagged item stands (SRS-LND-007).
type TrackedState string

const (
	// TrackedInService is an item in circulation.
	TrackedInService TrackedState = "in_service"
	// TrackedRetired is an item taken out of circulation — condemned,
	// damaged, or a uniform returned when somebody left.
	TrackedRetired TrackedState = "retired"
)

// Movement is one scan of a tracked item (SRS-LND-007).
type Movement struct {
	// Location is where it was read: a ward, the laundry, a machine, a
	// locker.
	Location string
	// HolderID is who had it, where the read identifies a person. Empty for
	// a location read, which is most of them: a portal scan at the laundry
	// door says where, not who.
	HolderID string
	// Note carries anything the scan itself cannot say.
	Note string
	// RecordedBy is the authenticated caller. A movement attributed to a
	// reader rather than a session is a movement anybody walking past the
	// reader can create.
	RecordedBy string
	At         time.Time
}

// TrackedItem is a tagged piece of linen or a uniform (SRS-LND-007).
type TrackedItem struct {
	ID       string
	TenantID string

	// TagID is what the reader returns. Unique within a tenant: two items
	// answering to one tag is a custody trail that belongs to neither.
	TagID    string
	TagKind  TagKind
	ItemCode string
	// AssignedTo is the person a uniform belongs to, where it belongs to
	// one. Separate from the current holder: a uniform in the laundry is
	// still that nurse's uniform.
	AssignedTo string
	FacilityID string

	State TrackedState
	// Movements are append-only, oldest first.
	Movements []Movement

	RetiredReason string
	RegisteredAt  time.Time
	RegisteredBy  string
	Version       int64
}

// NewTrackedInput registers a tagged item.
type NewTrackedInput struct {
	TagID      string
	TagKind    TagKind
	ItemCode   string
	AssignedTo string
	FacilityID string
}

// RegisterTag puts a tagged item into circulation (SRS-LND-007).
func RegisterTag(id, tenantID string, item LinenItem, in NewTrackedInput,
	by string, now time.Time) (TrackedItem, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return TrackedItem{}, fmt.Errorf("%w: a tracked item needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.TagID) == "":
		return TrackedItem{}, fmt.Errorf("%w: a tracked item needs its tag",
			ErrInvalidLaundry)
	case !knownTagKind[in.TagKind]:
		return TrackedItem{}, fmt.Errorf("%w: unknown tag kind %q",
			ErrInvalidLaundry, in.TagKind)
	case !strings.EqualFold(item.Code, in.ItemCode):
		return TrackedItem{}, fmt.Errorf(
			"%w: the tag is registered against item %q, not %q",
			ErrInvalidLaundry, item.Code, in.ItemCode)
	case !item.Tracked:
		// Tagging something the master does not call tracked produces a
		// custody trail for one sheet out of four thousand, which reads as
		// a system that lost the other three thousand nine hundred.
		return TrackedItem{}, fmt.Errorf(
			"%w: item %q is not a tracked item", ErrInvalidLaundry,
			item.Code)
	case !item.Active:
		return TrackedItem{}, fmt.Errorf("%w: item %q is retired",
			ErrInvalidLaundry, item.Code)
	case strings.TrimSpace(by) == "":
		return TrackedItem{}, fmt.Errorf(
			"%w: a registration names who made it", ErrInvalidLaundry)
	}

	return TrackedItem{
		ID: id, TenantID: tenantID,
		TagID: strings.TrimSpace(in.TagID), TagKind: in.TagKind,
		ItemCode:     item.Code,
		AssignedTo:   strings.TrimSpace(in.AssignedTo),
		FacilityID:   in.FacilityID,
		State:        TrackedInService,
		RegisteredAt: now.UTC(), RegisteredBy: by, Version: 1,
	}, nil
}

// RecordMovement appends a scan (SRS-LND-007).
//
// Append-only and never reordered. A movement list somebody can edit is a
// custody trail that says whatever the last person to touch it wanted, and
// the question a custody trail answers is always asked by somebody who
// suspects an answer.
func (t *TrackedItem) RecordMovement(location, holderID, note, by string,
	now time.Time) error {

	switch {
	case t.State != TrackedInService:
		return fmt.Errorf("%w: this item is %s",
			ErrInvalidLaundry, t.State)
	case strings.TrimSpace(location) == "":
		return fmt.Errorf("%w: a movement says where the item was read",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		// The scan does not replace the person: a movement with nobody
		// behind it is a movement anybody standing near the reader can
		// create.
		return fmt.Errorf("%w: a movement names who recorded it",
			ErrInvalidLaundry)
	}

	t.Movements = append(t.Movements, Movement{
		Location:   strings.TrimSpace(location),
		HolderID:   strings.TrimSpace(holderID),
		Note:       strings.TrimSpace(note),
		RecordedBy: by, At: now.UTC(),
	})
	return nil
}

// Retire takes a tagged item out of circulation (SRS-LND-007).
func (t *TrackedItem) Retire(reason, by string, now time.Time) error {
	switch {
	case t.State != TrackedInService:
		return fmt.Errorf("%w: this item is already %s",
			ErrInvalidLaundry, t.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the item is being retired",
			ErrInvalidLaundry)
	}
	t.State = TrackedRetired
	t.RetiredReason = strings.TrimSpace(reason)
	_ = by
	_ = now
	return nil
}

// Custody is where a tracked item was last seen (SRS-LND-007).
type Custody struct {
	Location   string
	HolderID   string
	RecordedBy string
	At         time.Time
	// Known is false for an item nobody has scanned since it was
	// registered. Reported rather than defaulting to the laundry, which
	// would put every unscanned item somewhere it may not be.
	Known bool
}

// LastKnown answers where a tracked item was last seen (SRS-LND-007).
func (t TrackedItem) LastKnown() Custody {
	if len(t.Movements) == 0 {
		return Custody{}
	}
	latest := t.Movements[0]
	for _, movement := range t.Movements[1:] {
		if movement.At.After(latest.At) {
			latest = movement
		}
	}
	return Custody{
		Location: latest.Location, HolderID: latest.HolderID,
		RecordedBy: latest.RecordedBy, At: latest.At, Known: true,
	}
}

// Stale is a tracked item nobody has seen for a while (SRS-LND-007).
type Stale struct {
	Item      TrackedItem
	Custody   Custody
	QuietDays int
	// NeverSeen is an item nobody has scanned at all since registration,
	// which appears first: a tag that never read once is more likely to be
	// a tag that does not work than a garment in a cupboard.
	NeverSeen bool
}

// StaleItems lists tracked items nobody has scanned recently
// (SRS-LND-007).
//
// A report rather than an action. Nothing here writes one off, because a
// uniform nobody has scanned for a month is usually a uniform somebody wore
// past a reader that was switched off.
func StaleItems(items []TrackedItem, quietFor time.Duration,
	at time.Time) []Stale {

	if quietFor <= 0 {
		return nil
	}
	var out []Stale
	for _, item := range items {
		if item.State != TrackedInService {
			continue
		}
		custody := item.LastKnown()
		if !custody.Known {
			out = append(out, Stale{
				Item: item, NeverSeen: true,
				QuietDays: int(at.Sub(item.RegisteredAt).Hours() / 24),
			})
			continue
		}
		if at.Sub(custody.At) < quietFor {
			continue
		}
		out = append(out, Stale{
			Item: item, Custody: custody,
			QuietDays: int(at.Sub(custody.At).Hours() / 24),
		})
	}

	sort.Slice(out, func(a, b int) bool {
		if out[a].NeverSeen != out[b].NeverSeen {
			return out[a].NeverSeen
		}
		if out[a].QuietDays != out[b].QuietDays {
			return out[a].QuietDays > out[b].QuietDays
		}
		return out[a].Item.TagID < out[b].Item.TagID
	})
	return out
}
