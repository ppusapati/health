package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Belongings and chain of custody (SRS-MORT-004).
//
// What somebody was wearing and carrying when they died is both the most
// ordinary and the most fraught thing a mortuary handles. It is a wedding
// ring, a phone, a wallet with money in it. The rule this file exists to hold
// is that every one of those things has an unbroken line from the moment it
// was listed to the moment somebody signed for it — and that the line cannot
// be rewritten, because a chain of custody somebody can edit is not one.

// ItemKind groups belongings for the counting that follows (SRS-MORT-004).
type ItemKind string

const (
	// ItemValuable is jewellery, cash, a watch: the things a family asks
	// about and an investigation asks about.
	ItemValuable ItemKind = "valuable"
	// ItemDocument is identity papers, a passport, a card.
	ItemDocument ItemKind = "document"
	// ItemClothing is what they were wearing, which in a medico-legal case
	// is evidence.
	ItemClothing ItemKind = "clothing"
	// ItemOther is everything else.
	ItemOther ItemKind = "other"
)

var knownItemKind = map[ItemKind]bool{
	ItemValuable: true, ItemDocument: true,
	ItemClothing: true, ItemOther: true,
}

// ItemState is where one belonging stands (SRS-MORT-004).
type ItemState string

const (
	// ItemHeld is in the mortuary's safe or its store.
	ItemHeld ItemState = "held"
	// ItemHandedOver has gone to somebody who signed for it.
	ItemHandedOver ItemState = "handed_over"
	// ItemRetained is held back by an authority: evidence a coroner or the
	// police have asked for. Its own state rather than a handover, because
	// the family has not got it and telling them it was handed over would
	// be untrue.
	ItemRetained ItemState = "retained"
)

// Item is one belonging (SRS-MORT-004).
type Item struct {
	ID       string
	TenantID string
	CaseID   string

	Kind        ItemKind
	Description string
	// Quantity because "three rings" is a different listing from "a ring",
	// and a family that gets two back needs the first to have been written
	// down.
	Quantity int

	State ItemState

	// SealNumber is the tamper-evident bag the item went into. A valuable
	// in an unsealed bag is a valuable nobody can say was not opened.
	SealNumber string

	ListedAt time.Time
	ListedBy string
	// WitnessedBy is the second person present at the listing. Required
	// for a valuable: a list of what was in somebody's pockets, made by
	// one person alone, is a list nobody can stand behind.
	WitnessedBy string

	HandoverID string
}

// NewItemInput lists one belonging.
type NewItemInput struct {
	Kind        ItemKind
	Description string
	Quantity    int
	SealNumber  string
	WitnessedBy string
}

// ListItem records one belonging into the mortuary's care (SRS-MORT-004).
func ListItem(id, tenantID string, c Case, in NewItemInput, by string,
	now time.Time) (Item, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Item{}, fmt.Errorf("%w: an item needs an id",
			ErrInvalidMortuary)
	case !knownItemKind[in.Kind]:
		return Item{}, fmt.Errorf("%w: unknown item kind %q",
			ErrInvalidMortuary, in.Kind)
	case strings.TrimSpace(in.Description) == "":
		return Item{}, fmt.Errorf("%w: an item says what it is",
			ErrInvalidMortuary)
	case in.Quantity <= 0:
		// "Zero rings" is not a listing. A quantity of nothing is an item
		// that will be signed for and was never there.
		return Item{}, fmt.Errorf("%w: an item says how many",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return Item{}, fmt.Errorf("%w: a listing names who made it",
			ErrInvalidMortuary)
	case in.Kind == ItemValuable &&
		strings.TrimSpace(in.WitnessedBy) == "":
		return Item{}, fmt.Errorf(
			"%w: listing a valuable needs a second person present",
			ErrInvalidMortuary)
	case in.Kind == ItemValuable &&
		strings.TrimSpace(in.WitnessedBy) == by:
		// One person signing as both is the control not working.
		return Item{}, fmt.Errorf(
			"%w: the witness to a valuable is somebody else",
			ErrInvalidMortuary)
	case in.Kind == ItemValuable &&
		strings.TrimSpace(in.SealNumber) == "":
		return Item{}, fmt.Errorf(
			"%w: a valuable goes into a numbered seal",
			ErrInvalidMortuary)
	}

	return Item{
		ID: id, TenantID: tenantID, CaseID: c.ID,
		Kind: in.Kind, Description: strings.TrimSpace(in.Description),
		Quantity: in.Quantity, State: ItemHeld,
		SealNumber: strings.TrimSpace(in.SealNumber),
		ListedAt:   now.UTC(), ListedBy: by,
		WitnessedBy: strings.TrimSpace(in.WitnessedBy),
	}, nil
}

// Retain marks an item an authority has taken (SRS-MORT-004, SRS-MORT-005).
func (i *Item) Retain(authority, reference string) error {
	switch {
	case i.State != ItemHeld:
		return fmt.Errorf("%w: this item is %s", ErrInvalidMortuary,
			i.State)
	case strings.TrimSpace(authority) == "":
		return fmt.Errorf("%w: a retention names the authority",
			ErrInvalidMortuary)
	case strings.TrimSpace(reference) == "":
		// The authority's own number for it, so the family can be told
		// who has their father's watch and under what reference.
		return fmt.Errorf("%w: a retention names the authority's reference",
			ErrInvalidMortuary)
	}
	i.State = ItemRetained
	return nil
}

// Handover is one act of giving belongings to somebody (SRS-MORT-004).
type Handover struct {
	ID       string
	TenantID string
	CaseID   string

	// RecipientName and RecipientRelation say who took them. A relation
	// rather than a free line, because "son" and "a man who came to the
	// desk" are different handovers.
	RecipientName     string
	RecipientRelation string
	// RecipientIDType and RecipientIDRef are the document the mortuary
	// checked. Belongings handed to somebody nobody asked for
	// identification from is the story that ends in a complaint.
	RecipientIDType string
	RecipientIDRef  string

	// SignatureRef points at the scanned signature or the signed register
	// page. A reference rather than an image: the document lives where
	// documents live, and a copy here goes stale.
	SignatureRef string

	ItemIDs []string

	HandedAt time.Time
	HandedBy string
	// WitnessedBy is the second member of staff present.
	WitnessedBy string
	Note        string
}

// NewHandoverInput hands belongings over.
type NewHandoverInput struct {
	RecipientName     string
	RecipientRelation string
	RecipientIDType   string
	RecipientIDRef    string
	SignatureRef      string
	WitnessedBy       string
	Note              string
}

// HandOver gives listed belongings to a named recipient (SRS-MORT-004).
//
// The items are passed in and mutated together with the handover, so a
// handover that names items it did not move cannot be written.
func HandOver(id, tenantID string, c Case, items []*Item,
	in NewHandoverInput, by string, now time.Time) (Handover, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Handover{}, fmt.Errorf("%w: a handover needs an id",
			ErrInvalidMortuary)
	case len(items) == 0:
		return Handover{}, fmt.Errorf("%w: a handover names what was given",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.RecipientName) == "":
		return Handover{}, fmt.Errorf("%w: a handover names who took them",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.RecipientIDType) == "" ||
		strings.TrimSpace(in.RecipientIDRef) == "":
		return Handover{}, fmt.Errorf(
			"%w: a handover records the recipient's identification",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.SignatureRef) == "":
		// SRS-MORT-004's acceptance names the signature reference
		// explicitly, and it is the only part of this a family can be
		// shown afterwards.
		return Handover{}, fmt.Errorf(
			"%w: a handover records the signature reference",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return Handover{}, fmt.Errorf("%w: a handover names who made it",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.WitnessedBy) == "":
		return Handover{}, fmt.Errorf(
			"%w: a handover needs a second member of staff present",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.WitnessedBy) == by:
		return Handover{}, fmt.Errorf(
			"%w: the witness to a handover is somebody else",
			ErrInvalidMortuary)
	}

	ids := make([]string, 0, len(items))
	for _, item := range items {
		switch {
		case item == nil:
			return Handover{}, fmt.Errorf("%w: a handover names an item",
				ErrInvalidMortuary)
		case item.CaseID != c.ID:
			// An item from another case in this handover is somebody
			// else's wedding ring going out of the door.
			return Handover{}, fmt.Errorf(
				"%w: item %s belongs to another case", ErrInvalidMortuary,
				item.ID)
		case item.State == ItemRetained:
			// The family cannot be given what the coroner has.
			return Handover{}, fmt.Errorf(
				"%w: item %s is retained by an authority",
				ErrInvalidMortuary, item.ID)
		case item.State != ItemHeld:
			return Handover{}, fmt.Errorf("%w: item %s is %s",
				ErrInvalidMortuary, item.ID, item.State)
		}
		ids = append(ids, item.ID)
	}

	for _, item := range items {
		item.State = ItemHandedOver
		item.HandoverID = id
	}

	return Handover{
		ID: id, TenantID: tenantID, CaseID: c.ID,
		RecipientName:     strings.TrimSpace(in.RecipientName),
		RecipientRelation: strings.TrimSpace(in.RecipientRelation),
		RecipientIDType:   strings.TrimSpace(in.RecipientIDType),
		RecipientIDRef:    strings.TrimSpace(in.RecipientIDRef),
		SignatureRef:      strings.TrimSpace(in.SignatureRef),
		ItemIDs:           ids,
		HandedAt:          now.UTC(), HandedBy: by,
		WitnessedBy: strings.TrimSpace(in.WitnessedBy),
		Note:        strings.TrimSpace(in.Note),
	}, nil
}

// Outstanding lists what the mortuary still holds for a case
// (SRS-MORT-004, SRS-MORT-006).
//
// The list a release is checked against: a body released while the family's
// belongings are still in the safe is a second visit nobody wants to make.
func Outstanding(items []Item, caseID string) []Item {
	out := make([]Item, 0, len(items))
	for _, item := range items {
		if item.CaseID == caseID && item.State == ItemHeld {
			out = append(out, item)
		}
	}
	// Valuables first: they are what somebody will come back for.
	sort.SliceStable(out, func(i, j int) bool {
		if (out[i].Kind == ItemValuable) != (out[j].Kind == ItemValuable) {
			return out[i].Kind == ItemValuable
		}
		return out[i].ListedAt.Before(out[j].ListedAt)
	})
	return out
}

// CustodyEntry is one line of the chain of custody (SRS-MORT-004).
//
// Append-only. Every movement of the body and of its belongings lands here,
// and nothing edits or deletes one: a chain somebody can rewrite says
// whatever the last person to touch it wanted it to say.
type CustodyEntry struct {
	ID       string
	TenantID string
	CaseID   string

	// Event is what happened, in the mortuary's own words: received,
	// placed, moved, viewed, released, belongings handed over.
	Event string
	// Detail is the short human line beside it. No cause of death and no
	// medico-legal narrative: the chain is read more widely than the case.
	Detail string

	// FromParty and ToParty are the two ends of the movement, where it had
	// two. "From the ward, to the mortuary attendant" is the shape.
	FromParty string
	ToParty   string

	RecordedAt time.Time
	RecordedBy string
}

// RecordCustody appends one line (SRS-MORT-004).
func RecordCustody(id, tenantID, caseID, event, detail, fromParty,
	toParty, by string, now time.Time) (CustodyEntry, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CustodyEntry{}, fmt.Errorf("%w: a custody entry needs an id",
			ErrInvalidMortuary)
	case strings.TrimSpace(caseID) == "":
		return CustodyEntry{}, fmt.Errorf("%w: a custody entry names its case",
			ErrInvalidMortuary)
	case strings.TrimSpace(event) == "":
		return CustodyEntry{}, fmt.Errorf(
			"%w: a custody entry says what happened", ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		// A chain of custody attributed to nobody is a chain with a gap
		// in it exactly where somebody would want one.
		return CustodyEntry{}, fmt.Errorf(
			"%w: a custody entry names who recorded it", ErrInvalidMortuary)
	}

	return CustodyEntry{
		ID: id, TenantID: tenantID, CaseID: caseID,
		Event:      strings.TrimSpace(event),
		Detail:     strings.TrimSpace(detail),
		FromParty:  strings.TrimSpace(fromParty),
		ToParty:    strings.TrimSpace(toParty),
		RecordedAt: now.UTC(), RecordedBy: by,
	}, nil
}

// Chain orders a case's custody entries oldest first (SRS-MORT-004).
func Chain(entries []CustodyEntry, caseID string) []CustodyEntry {
	out := make([]CustodyEntry, 0, len(entries))
	for _, entry := range entries {
		if entry.CaseID == caseID {
			out = append(out, entry)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].RecordedAt.Before(out[j].RecordedAt)
	})
	return out
}
