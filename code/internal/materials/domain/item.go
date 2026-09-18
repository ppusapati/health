// Package domain holds the materials, procurement and inventory rules
// (SRS-MAT-001 … 016).
//
// No infrastructure: the rules here are the ones a storekeeper or a buyer
// would recognise as theirs, and they are testable without a database
// (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidMaterials refuses a materials record that could not be true.
var ErrInvalidMaterials = errors.New("materials: invalid")

// Tracking is how finely one item is identified (SRS-MAT-005, SRS-MAT-007).
//
// The choice is the item's, not the deployment's. A box of gloves is counted;
// a batch of sutures is tracked to its lot because a recall reaches lots; an
// implant is tracked to its serial because a recall reaches the patient it
// went into.
type Tracking string

const (
	// TrackingQuantity counts. A shortfall is a number, and a recall on this
	// item can only reach the whole stock of it.
	TrackingQuantity Tracking = "quantity"
	// TrackingBatch identifies a manufacturing lot, which is what a supplier
	// recall names and what an expiry belongs to.
	TrackingBatch Tracking = "batch"
	// TrackingSerial identifies one physical object. Required for an implant:
	// SRS-MAT-016's patient-specific implants and SRS-OT-010's implant record
	// both name a serial, and a recall on one runs to a person.
	TrackingSerial Tracking = "serial"
)

var knownTracking = map[Tracking]bool{
	TrackingQuantity: true, TrackingBatch: true, TrackingSerial: true,
}

// RequiresLot reports an item whose stock cannot exist without a lot identity.
func (t Tracking) RequiresLot() bool { return t != TrackingQuantity }

// PickPolicy is the order stock is recommended in (SRS-MAT-009).
type PickPolicy string

const (
	// PickFEFO takes the earliest expiry first. The default for anything
	// perishable, because the alternative throws away stock that was in date
	// when somebody could have used it.
	PickFEFO PickPolicy = "fefo"
	// PickFIFO takes the earliest received first. For items that do not
	// expire but do deteriorate or become obsolete.
	PickFIFO PickPolicy = "fifo"
	// PickSerial is for items chosen one at a time by a person — an implant
	// picked for a patient — where a recommendation is advice and the choice
	// is clinical.
	PickSerial PickPolicy = "serial"
)

var knownPickPolicies = map[PickPolicy]bool{
	PickFEFO: true, PickFIFO: true, PickSerial: true,
}

// Item is one line of the materials master (SRS-MAT-001).
type Item struct {
	ID       string
	TenantID string

	// Code is the catalogue code, unique within the tenant. It is what a
	// requisition, a purchase order and a stock movement all name.
	Code    string
	Display string
	// Category drives the approval route and whether receipts are inspected
	// (SRS-MAT-002, SRS-MAT-006).
	Category string

	// UOM is the unit stock is held and issued in. One unit throughout:
	// purchasing in boxes and issuing in pieces is a real requirement and a
	// real source of hundredfold errors, so a conversion is recorded on the
	// purchase line rather than implied here.
	UOM string

	Tracking Tracking
	Policy   PickPolicy
	// Perishable marks an item with an expiry. A perishable item's stock
	// cannot be received without one.
	Perishable bool
	// InspectOnReceipt holds a receipt in quarantine until somebody accepts it
	// (SRS-MAT-006).
	InspectOnReceipt bool

	// Consignable marks an item a supplier may leave on the shelf unpaid
	// (SRS-MAT-016). Stock of an item that is not consignable cannot be
	// received as consignment, which stops a storekeeper accidentally
	// recording the hospital's own stock as somebody else's.
	Consignable bool

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewItemInput adds an item to the master.
type NewItemInput struct {
	Code             string
	Display          string
	Category         string
	UOM              string
	Tracking         Tracking
	Policy           PickPolicy
	Perishable       bool
	InspectOnReceipt bool
	Consignable      bool
}

// NewItem adds an item to the master (SRS-MAT-001).
func NewItem(id, tenantID string, in NewItemInput, by string,
	now time.Time) (Item, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Item{}, fmt.Errorf("%w: an item needs an id", ErrInvalidMaterials)
	case strings.TrimSpace(in.Code) == "":
		return Item{}, fmt.Errorf("%w: an item needs a catalogue code",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.UOM) == "":
		// Without a unit, a quantity is a number with no meaning, and every
		// balance built from it is a number with no meaning.
		return Item{}, fmt.Errorf("%w: an item needs a unit of measure",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Item{}, fmt.Errorf("%w: an item names who added it",
			ErrInvalidMaterials)
	}

	tracking := in.Tracking
	if tracking == "" {
		tracking = TrackingQuantity
	}
	if !knownTracking[tracking] {
		return Item{}, fmt.Errorf("%w: unknown tracking %q",
			ErrInvalidMaterials, tracking)
	}

	policy := in.Policy
	if policy == "" {
		// A perishable item defaults to FEFO. Anything else defaults to FIFO,
		// and a serial-tracked item to serial picking. Each default is the one
		// that wastes least, and each is overridable.
		switch {
		case in.Perishable:
			policy = PickFEFO
		case tracking == TrackingSerial:
			policy = PickSerial
		default:
			policy = PickFIFO
		}
	}
	if !knownPickPolicies[policy] {
		return Item{}, fmt.Errorf("%w: unknown pick policy %q",
			ErrInvalidMaterials, policy)
	}
	if in.Perishable && policy == PickFIFO {
		// Received-first on an expiring item throws away stock that was in
		// date while somebody was using a newer box. If a deployment means it,
		// it says so by making the item non-perishable, which is a different
		// claim and a visible one.
		return Item{}, fmt.Errorf(
			"%w: a perishable item is picked earliest-expiry-first, not "+
				"earliest-received-first", ErrInvalidMaterials)
	}
	if in.Tracking == TrackingQuantity && in.Perishable {
		// An expiry belongs to a lot. An item counted in bulk has no lot to
		// hang one on, so "perishable" here would be a promise nothing could
		// keep.
		return Item{}, fmt.Errorf(
			"%w: a perishable item is tracked by batch or serial, because an "+
				"expiry belongs to a lot", ErrInvalidMaterials)
	}

	return Item{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Display: strings.TrimSpace(in.Display),
		Category: strings.TrimSpace(in.Category), UOM: strings.TrimSpace(in.UOM),
		Tracking: tracking, Policy: policy,
		Perishable: in.Perishable, InspectOnReceipt: in.InspectOnReceipt,
		Consignable: in.Consignable, Active: true,
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Ownership is who owns stock sitting on the hospital's shelf (SRS-MAT-016).
type Ownership string

const (
	// OwnedByHospital is stock the hospital has bought.
	OwnedByHospital Ownership = "hospital"
	// OwnedConsignment is the supplier's stock, held here unpaid. It becomes
	// the hospital's at consumption, which is the moment the contract says a
	// charge and a liability arise.
	OwnedConsignment Ownership = "consignment"
)

var knownOwnership = map[Ownership]bool{
	OwnedByHospital: true, OwnedConsignment: true,
}

// Lot is one identified quantity of an item (SRS-MAT-005, SRS-MAT-013).
//
// A lot rather than a batch, because the same structure holds a serial: a
// serial-tracked lot is a lot of one. Keeping them one type means the recall
// path, the expiry path and the ownership path are written once instead of
// three times with two of them subtly different.
type Lot struct {
	ID       string
	TenantID string
	ItemID   string

	// Code is the manufacturer's batch or the serial number. Empty only for a
	// quantity-tracked item, where the lot stands for "stock of this item"
	// and carries no identity.
	Code string
	// Expiry is when the lot goes out of date. Zero for an item that does not
	// expire.
	Expiry time.Time
	// ReceivedAt is what FIFO orders by.
	ReceivedAt time.Time

	Ownership Ownership
	// SupplierID owns consignment stock and is who a liability is raised
	// against.
	SupplierID string

	// Blocked stops the lot being issued at all: a recall, a quality hold, a
	// storage failure (SRS-MAT-013). Blocked stock still exists and is still
	// counted; it is simply not available to anybody.
	Blocked       bool
	BlockedReason string
	BlockedAt     time.Time
	BlockedBy     string

	CreatedAt time.Time
	Version   int64
}

// NewLotInput identifies a received quantity.
type NewLotInput struct {
	ItemID     string
	Code       string
	Expiry     time.Time
	Ownership  Ownership
	SupplierID string
}

// NewLot identifies a received quantity (SRS-MAT-005).
func NewLot(id, tenantID string, in NewLotInput, item Item,
	now time.Time) (Lot, error) {

	code := strings.TrimSpace(in.Code)
	switch {
	case strings.TrimSpace(id) == "":
		return Lot{}, fmt.Errorf("%w: a lot needs an id", ErrInvalidMaterials)
	case strings.TrimSpace(in.ItemID) == "":
		return Lot{}, fmt.Errorf("%w: a lot names its item", ErrInvalidMaterials)
	case item.Tracking.RequiresLot() && code == "":
		// The identity is the whole point of tracking: a recall on a batch
		// that nobody recorded reaches every unit of the item or none.
		return Lot{}, fmt.Errorf("%w: %s is tracked by %s and needs one",
			ErrInvalidMaterials, item.Code, item.Tracking)
	case item.Perishable && in.Expiry.IsZero():
		// A perishable item with no expiry never expires, which is the one
		// direction that lets out-of-date stock reach a patient.
		return Lot{}, fmt.Errorf("%w: %s expires and this receipt says when it "+
			"does not", ErrInvalidMaterials, item.Code)
	}

	ownership := in.Ownership
	if ownership == "" {
		ownership = OwnedByHospital
	}
	if !knownOwnership[ownership] {
		return Lot{}, fmt.Errorf("%w: unknown ownership %q",
			ErrInvalidMaterials, ownership)
	}
	if ownership == OwnedConsignment {
		switch {
		case !item.Consignable:
			// Otherwise a keystroke turns the hospital's own stock into
			// somebody else's, and the error surfaces as an invoice.
			return Lot{}, fmt.Errorf(
				"%w: %s is not held on consignment", ErrInvalidMaterials, item.Code)
		case strings.TrimSpace(in.SupplierID) == "":
			// Consignment stock that names no owner cannot raise the
			// liability its consumption is supposed to raise.
			return Lot{}, fmt.Errorf(
				"%w: consignment stock names the supplier that owns it",
				ErrInvalidMaterials)
		}
	}

	return Lot{
		ID: id, TenantID: tenantID, ItemID: strings.TrimSpace(in.ItemID),
		Code: code, Expiry: in.Expiry.UTC(), ReceivedAt: now.UTC(),
		Ownership: ownership, SupplierID: strings.TrimSpace(in.SupplierID),
		CreatedAt: now.UTC(), Version: 1,
	}, nil
}

// Expired reports a lot past its date.
func (l Lot) Expired(now time.Time) bool {
	return !l.Expiry.IsZero() && !now.Before(l.Expiry)
}

// Issuable reports a lot that may be picked (SRS-MAT-009, SRS-MAT-013).
//
// Blocked and expired fail independently, and both are checked here rather
// than by each caller: the two ways stock that looks usable is not.
func (l Lot) Issuable(now time.Time) bool {
	return !l.Blocked && !l.Expired(now)
}

// Block stops a lot being issued (SRS-MAT-013).
func (l *Lot) Block(reason, by string, now time.Time) error {
	switch {
	case l.Blocked:
		return fmt.Errorf("%w: this lot is already blocked", ErrInvalidMaterials)
	case strings.TrimSpace(reason) == "":
		// A block with no reason cannot be reviewed, and nobody will ever be
		// confident enough to lift it.
		return fmt.Errorf("%w: say why this lot is blocked", ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a block names who raised it", ErrInvalidMaterials)
	}
	l.Blocked, l.BlockedReason = true, strings.TrimSpace(reason)
	l.BlockedAt, l.BlockedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// Release lifts a block (SRS-MAT-013).
func (l *Lot) Release(by string) error {
	switch {
	case !l.Blocked:
		return fmt.Errorf("%w: this lot is not blocked", ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: lifting a block names who did it",
			ErrInvalidMaterials)
	}
	l.Blocked, l.BlockedReason = false, ""
	l.BlockedAt, l.BlockedBy = time.Time{}, ""
	return nil
}

// Supplier is somebody the hospital buys from (SRS-MAT-003).
type Supplier struct {
	ID       string
	TenantID string

	Code    string
	Display string
	// Approved gates who may be sent an RFQ or a purchase order. An
	// unapproved supplier is not a supplier a hospital buys from, which is
	// what "approved suppliers" in SRS-MAT-003 means when it is enforced
	// rather than assumed.
	Approved bool

	ContactEmail string
	ContactPhone string
	// PaymentTermsDays and Currency normalise a bid: two quotes on different
	// terms are not comparable until they are on the same ones.
	PaymentTermsDays int
	Currency         string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewSupplierInput registers a supplier.
type NewSupplierInput struct {
	Code             string
	Display          string
	ContactEmail     string
	ContactPhone     string
	PaymentTermsDays int
	Currency         string
	Approved         bool
}

// NewSupplier registers a supplier (SRS-MAT-003).
func NewSupplier(id, tenantID string, in NewSupplierInput, by string,
	now time.Time) (Supplier, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Supplier{}, fmt.Errorf("%w: a supplier needs an id",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.Code) == "":
		return Supplier{}, fmt.Errorf("%w: a supplier needs a code",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.Display) == "":
		return Supplier{}, fmt.Errorf("%w: a supplier needs a name",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Supplier{}, fmt.Errorf("%w: a supplier names who registered it",
			ErrInvalidMaterials)
	}

	currency := strings.TrimSpace(in.Currency)
	if currency == "" {
		currency = "INR"
	}

	return Supplier{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Display: strings.TrimSpace(in.Display),
		Approved:         in.Approved,
		ContactEmail:     strings.TrimSpace(in.ContactEmail),
		ContactPhone:     strings.TrimSpace(in.ContactPhone),
		PaymentTermsDays: in.PaymentTermsDays, Currency: currency,
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// StockLevel is one item's min-max policy at one location (SRS-MAT-012).
type StockLevel struct {
	ItemID     string
	LocationID string
	// Minimum is the level a reorder is suggested at. Zero means the item is
	// not replenished automatically here, which is a decision rather than a
	// gap: not every store carries every item.
	Minimum int
	// Maximum is what a suggested order tops up to.
	Maximum int
	// ReorderQuantity overrides top-up where a supplier sells in packs.
	ReorderQuantity int
}

// Validate refuses a policy that could not be followed.
func (s StockLevel) Validate() error {
	switch {
	case strings.TrimSpace(s.ItemID) == "":
		return fmt.Errorf("%w: a stock level names its item", ErrInvalidMaterials)
	case strings.TrimSpace(s.LocationID) == "":
		return fmt.Errorf("%w: a stock level names its location",
			ErrInvalidMaterials)
	case s.Minimum < 0 || s.Maximum < 0 || s.ReorderQuantity < 0:
		return fmt.Errorf("%w: a stock level is not negative", ErrInvalidMaterials)
	case s.Maximum > 0 && s.Maximum < s.Minimum:
		// A maximum below the minimum makes every top-up an order for a
		// negative quantity, which the suggestion would then round to nothing
		// and the store would silently never reorder.
		return fmt.Errorf("%w: a maximum below the minimum can never be topped up to",
			ErrInvalidMaterials)
	}
	return nil
}

// sortedCodes returns a stable, de-duplicated list.
func sortedCodes(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		trimmed := strings.TrimSpace(value)
		if trimmed == "" || seen[trimmed] {
			continue
		}
		seen[trimmed] = true
		out = append(out, trimmed)
	}
	sort.Strings(out)
	return out
}
