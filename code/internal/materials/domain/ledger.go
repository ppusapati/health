package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// StockStatus is what stock in a location may be used for (SRS-MAT-006,
// SRS-MAT-007, SRS-MAT-010).
//
// A status rather than a flag on the item, because the same lot can be partly
// available and partly quarantined: a second delivery of the same batch is
// inspected on its own.
type StockStatus string

const (
	// StatusQuarantine is received and not yet accepted. SRS-MAT-006's clause
	// is that unaccepted stock cannot become available, and this is where it
	// bites: quarantined stock is counted and is not issuable.
	StatusQuarantine StockStatus = "quarantine"
	// StatusAvailable is stock somebody may pick.
	StatusAvailable StockStatus = "available"
	// StatusInTransit is stock that has left one store and not arrived at the
	// next (SRS-MAT-010). A status rather than a flag, so a transfer is two
	// movements and nothing is ever nowhere.
	StatusInTransit StockStatus = "in_transit"
	// StatusRejected failed inspection and is awaiting return to the supplier
	// or disposal. Counted, never issuable.
	StatusRejected StockStatus = "rejected"
)

var knownStatuses = map[StockStatus]bool{
	StatusQuarantine: true, StatusAvailable: true,
	StatusInTransit: true, StatusRejected: true,
}

// Bucket is where a quantity of one lot sits: a location and a status.
//
// The unit the ledger balances. Every movement takes a quantity out of one
// bucket and puts it into another, so "on-hand" is a sum over movements rather
// than a number somebody maintains — which is what SRS-MAT-007's "on-hand is
// derivable from immutable movements" asks for.
type Bucket struct {
	LocationID string
	Status     StockStatus
}

// Outside is the bucket beyond the hospital's walls: the supplier a receipt
// comes from, the patient a consumable goes into, the bin a rejected lot is
// thrown in.
//
// Named rather than left as a zero value so that a movement with neither side
// inside the hospital is a thing the code can refuse.
var Outside = Bucket{}

// Inside reports a bucket the hospital holds stock in.
func (b Bucket) Inside() bool { return b.LocationID != "" }

// Issuable reports a bucket stock may be picked from.
func (b Bucket) Issuable() bool {
	return b.Inside() && b.Status == StatusAvailable
}

func (b Bucket) String() string {
	if !b.Inside() {
		return "outside"
	}
	return b.LocationID + "/" + string(b.Status)
}

// MovementKind is why stock moved (SRS-MAT-007).
//
// The kind is not what the ledger balances on — the buckets are — but it is
// what every report groups by, and a movement whose kind nobody recorded is a
// row no analysis can classify.
type MovementKind string

const (
	MovementReceipt MovementKind = "receipt"
	// MovementAccept releases quarantined stock (SRS-MAT-006).
	MovementAccept MovementKind = "accept"
	MovementReject MovementKind = "reject"
	// MovementIssue sends stock to a department, a patient or a cost centre
	// (SRS-MAT-008).
	MovementIssue  MovementKind = "issue"
	MovementReturn MovementKind = "return"
	// MovementTransferOut and MovementTransferIn are the two halves of a
	// transfer between stores (SRS-MAT-010).
	MovementTransferOut MovementKind = "transfer_out"
	MovementTransferIn  MovementKind = "transfer_in"
	// MovementAdjustment corrects the ledger after a count (SRS-MAT-011). It
	// is the only kind that can create or destroy stock without a physical
	// event, which is why it needs an approval and a reason.
	MovementAdjustment MovementKind = "adjustment"
	// MovementConsumption is stock used on a patient, which is what turns
	// consignment stock into the hospital's (SRS-MAT-016).
	MovementConsumption MovementKind = "consumption"
	// MovementDisposal writes off expired or damaged stock.
	MovementDisposal MovementKind = "disposal"
)

var knownMovementKinds = map[MovementKind]bool{
	MovementReceipt: true, MovementAccept: true, MovementReject: true,
	MovementIssue: true, MovementReturn: true,
	MovementTransferOut: true, MovementTransferIn: true,
	MovementAdjustment: true, MovementConsumption: true,
	MovementDisposal: true,
}

// Movement is one immutable transfer of quantity between buckets
// (SRS-MAT-007).
//
// Double-entry on purpose. A quantity always leaves somewhere and arrives
// somewhere, and at most one of those may be outside the hospital. Written
// that way, conservation is a property of the row rather than of the code that
// wrote it: no movement can create stock in one place without removing it from
// another, and a balance is a sum.
//
// Never updated and never deleted. A mistake is corrected by a compensating
// movement, which leaves both the mistake and the correction visible — the
// difference between a store whose count was wrong on Tuesday and a store
// whose ledger says it never was.
type Movement struct {
	ID       string
	TenantID string

	ItemID string
	LotID  string

	From Bucket
	To   Bucket
	// Quantity is always positive. The direction is the buckets' job; a signed
	// quantity would give every sum two ways to be wrong.
	Quantity int

	Kind MovementKind
	// Reference names the document this movement belongs to: the GRN, the
	// issue note, the transfer, the count. What makes a movement auditable
	// back to a decision rather than an entry somebody made.
	Reference string
	Reason    string

	// CostCentre is who the stock was issued against (SRS-MAT-008).
	CostCentre string
	// PatientID and EncounterID link a consumption to the chargeable event
	// (SRS-MAT-008, SRS-MAT-016). Empty for a movement between stores.
	PatientID   string
	EncounterID string

	OccurredAt time.Time
	RecordedBy string
}

// NewMovementInput records one movement.
type NewMovementInput struct {
	ItemID      string
	LotID       string
	From        Bucket
	To          Bucket
	Quantity    int
	Kind        MovementKind
	Reference   string
	Reason      string
	CostCentre  string
	PatientID   string
	EncounterID string
}

// NewMovement records one transfer of quantity (SRS-MAT-007).
func NewMovement(id, tenantID string, in NewMovementInput, by string,
	now time.Time) (Movement, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Movement{}, fmt.Errorf("%w: a movement needs an id",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.ItemID) == "":
		return Movement{}, fmt.Errorf("%w: a movement names its item",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.LotID) == "":
		// Even a quantity-tracked item has a lot row: it is what carries
		// ownership and the received date, and without one a movement cannot
		// be attributed to anything a recall or a FIFO pick could find.
		return Movement{}, fmt.Errorf("%w: a movement names its lot",
			ErrInvalidMaterials)
	case in.Quantity <= 0:
		// Zero moves nothing and would sit in the ledger looking like an
		// event. Negative would make the direction ambiguous when the buckets
		// already carry it.
		return Movement{}, fmt.Errorf("%w: a movement moves a positive quantity",
			ErrInvalidMaterials)
	case !knownMovementKinds[in.Kind]:
		return Movement{}, fmt.Errorf("%w: unknown movement kind %q",
			ErrInvalidMaterials, in.Kind)
	case strings.TrimSpace(by) == "":
		return Movement{}, fmt.Errorf("%w: a movement names who recorded it",
			ErrInvalidMaterials)
	}

	if err := checkBuckets(in.From, in.To); err != nil {
		return Movement{}, err
	}

	return Movement{
		ID: id, TenantID: tenantID,
		ItemID: strings.TrimSpace(in.ItemID), LotID: strings.TrimSpace(in.LotID),
		From: in.From, To: in.To, Quantity: in.Quantity, Kind: in.Kind,
		Reference:   strings.TrimSpace(in.Reference),
		Reason:      strings.TrimSpace(in.Reason),
		CostCentre:  strings.TrimSpace(in.CostCentre),
		PatientID:   strings.TrimSpace(in.PatientID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		OccurredAt:  now.UTC(), RecordedBy: strings.TrimSpace(by),
	}, nil
}

func checkBuckets(from, to Bucket) error {
	if from.Inside() && !knownStatuses[from.Status] {
		return fmt.Errorf("%w: unknown stock status %q",
			ErrInvalidMaterials, from.Status)
	}
	if to.Inside() && !knownStatuses[to.Status] {
		return fmt.Errorf("%w: unknown stock status %q",
			ErrInvalidMaterials, to.Status)
	}
	switch {
	case !from.Inside() && !to.Inside():
		// Both sides outside is a row that changes no balance anywhere: an
		// entry that looks like stock moving and is not.
		return fmt.Errorf(
			"%w: a movement has at least one side inside the hospital",
			ErrInvalidMaterials)
	case from == to:
		// Same bucket to same bucket nets to nothing and would let somebody
		// record activity that never happened.
		return fmt.Errorf("%w: a movement goes somewhere else", ErrInvalidMaterials)
	}
	return nil
}

// Balance is what one lot holds in one bucket.
type Balance struct {
	ItemID   string
	LotID    string
	Bucket   Bucket
	Quantity int
}

// key identifies a balance line.
type balanceKey struct {
	itemID string
	lotID  string
	bucket Bucket
}

// Balances derives on-hand from movements (SRS-MAT-007).
//
// The whole of "on-hand is derivable from immutable movements". No maintained
// total anywhere: the number is this sum, so a store's balance and its ledger
// cannot disagree — there is only one of them.
//
// Buckets outside the hospital are not reported. A negative running total on
// the outside bucket is not a fact about anything: it is just the count of
// what has come in.
func Balances(movements []Movement) []Balance {
	totals := map[balanceKey]int{}
	for _, m := range movements {
		if m.From.Inside() {
			totals[balanceKey{m.ItemID, m.LotID, m.From}] -= m.Quantity
		}
		if m.To.Inside() {
			totals[balanceKey{m.ItemID, m.LotID, m.To}] += m.Quantity
		}
	}

	out := make([]Balance, 0, len(totals))
	for key, quantity := range totals {
		if quantity == 0 {
			// A bucket that emptied is not a bucket holding nothing; it is a
			// line a stock report should not print.
			continue
		}
		out = append(out, Balance{
			ItemID: key.itemID, LotID: key.lotID,
			Bucket: key.bucket, Quantity: quantity,
		})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].ItemID != out[j].ItemID {
			return out[i].ItemID < out[j].ItemID
		}
		if out[i].Bucket.LocationID != out[j].Bucket.LocationID {
			return out[i].Bucket.LocationID < out[j].Bucket.LocationID
		}
		if out[i].Bucket.Status != out[j].Bucket.Status {
			return out[i].Bucket.Status < out[j].Bucket.Status
		}
		return out[i].LotID < out[j].LotID
	})
	return out
}

// OnHand totals one item at one location across every status.
//
// What a stocktake counts: quarantined stock is on the shelf whether or not
// anybody may use it.
func OnHand(balances []Balance, itemID, locationID string) int {
	total := 0
	for _, b := range balances {
		if b.ItemID == itemID && b.Bucket.LocationID == locationID {
			total += b.Quantity
		}
	}
	return total
}

// Available totals what could actually be issued (SRS-MAT-006, SRS-MAT-013).
//
// Available-to-promise. Three things keep stock out of it, and each fails
// independently: the wrong status, a blocked lot, and an expired one. A caller
// that checked only the status would offer quarantined stock; one that checked
// only the lot would offer stock in transit.
func Available(balances []Balance, lots map[string]Lot, itemID,
	locationID string, now time.Time) int {

	total := 0
	for _, b := range balances {
		if b.ItemID != itemID || b.Bucket.LocationID != locationID {
			continue
		}
		if !b.Bucket.Issuable() {
			continue
		}
		lot, known := lots[b.LotID]
		if !known || !lot.Issuable(now) {
			continue
		}
		total += b.Quantity
	}
	return total
}

// PickLine is one lot a pick recommendation suggests taking from.
type PickLine struct {
	LotID    string
	LotCode  string
	Bucket   Bucket
	Quantity int
	Expiry   time.Time
}

// Pick is a recommendation, with what it could not satisfy.
type Pick struct {
	ItemID string
	Lines  []PickLine
	// Short is the quantity the location could not supply. Returned rather
	// than refused: a storekeeper facing a shortfall needs to know how much to
	// chase, and a recommendation that returned nothing at all would send them
	// to another store for the whole quantity.
	Short int
	// Skipped names lots that were passed over and why, so a storekeeper
	// looking at a full shelf and a short pick can see the reason rather than
	// assume the system is wrong.
	Skipped []string
}

// Recommend suggests which lots to pick from (SRS-MAT-009).
//
// A recommendation, not an instruction: the requirement's acceptance is "pick
// recommendation respects item policy", and the person at the shelf can see
// things this cannot — a crushed box, a label that does not match. What the
// system owes them is the right order and an honest account of what it left
// out.
func Recommend(item Item, balances []Balance, lots map[string]Lot,
	locationID string, quantity int, now time.Time) Pick {

	out := Pick{ItemID: item.ID, Short: quantity}
	if quantity <= 0 {
		out.Short = 0
		return out
	}

	type candidate struct {
		balance Balance
		lot     Lot
	}
	var usable []candidate
	var skipped []string

	for _, b := range balances {
		if b.ItemID != item.ID || b.Bucket.LocationID != locationID ||
			b.Quantity <= 0 {
			continue
		}
		lot, known := lots[b.LotID]
		if !known {
			skipped = append(skipped, "a lot with no record was passed over")
			continue
		}
		switch {
		case !b.Bucket.Issuable():
			skipped = append(skipped, lotLabel(lot)+" is "+string(b.Bucket.Status))
		case lot.Blocked:
			// The recall path. SRS-MAT-013's clause is that blocked lots are
			// excluded from ATP, and this is the place a picker would
			// otherwise reach past it.
			skipped = append(skipped, lotLabel(lot)+" is blocked: "+lot.BlockedReason)
		case lot.Expired(now):
			skipped = append(skipped, lotLabel(lot)+" expired on "+
				lot.Expiry.Format("2006-01-02"))
		default:
			usable = append(usable, candidate{balance: b, lot: lot})
		}
	}

	sort.SliceStable(usable, func(i, j int) bool {
		a, b := usable[i].lot, usable[j].lot
		switch item.Policy {
		case PickFEFO:
			// Earliest expiry first. A lot with no expiry sorts last: it can
			// wait, and the one that will be thrown away cannot.
			ai, bi := a.Expiry.IsZero(), b.Expiry.IsZero()
			if ai != bi {
				return bi
			}
			if !a.Expiry.Equal(b.Expiry) {
				return a.Expiry.Before(b.Expiry)
			}
		case PickFIFO, PickSerial:
			if !a.ReceivedAt.Equal(b.ReceivedAt) {
				return a.ReceivedAt.Before(b.ReceivedAt)
			}
		}
		// A stable tie-break, so the same shelf produces the same advice
		// twice. A recommendation that reordered itself between two screens
		// is one a storekeeper stops believing.
		return a.ID < b.ID
	})

	remaining := quantity
	for _, c := range usable {
		if remaining == 0 {
			break
		}
		take := c.balance.Quantity
		if take > remaining {
			take = remaining
		}
		out.Lines = append(out.Lines, PickLine{
			LotID: c.lot.ID, LotCode: c.lot.Code, Bucket: c.balance.Bucket,
			Quantity: take, Expiry: c.lot.Expiry,
		})
		remaining -= take
	}
	out.Short = remaining
	out.Skipped = sortedCodes(skipped)
	return out
}

func lotLabel(l Lot) string {
	if l.Code == "" {
		return "lot " + l.ID
	}
	return "lot " + l.Code
}
