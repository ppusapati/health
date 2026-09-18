package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// POState is where a purchase order has got to.
type POState string

const (
	PODraft     POState = "draft"
	POIssued    POState = "issued"
	POPartial   POState = "partly_received"
	POReceived  POState = "received"
	POClosed    POState = "closed"
	POCancelled POState = "cancelled"
)

// POLine is one item ordered (SRS-MAT-004).
type POLine struct {
	ItemID   string
	ItemCode string
	// Quantity is in purchase units; PackSize converts to stock units. Both
	// are carried because a receipt is counted in stock units and an invoice
	// is priced in purchase units, and the conversion is the thing that goes
	// wrong.
	Quantity int
	PackSize int
	UOM      string

	UnitPrice Money
	// TaxMinor and DiscountMinor are per line, because tax rates differ by
	// item category and a single order-level figure cannot be checked against
	// an invoice line.
	TaxMinor      int64
	DiscountMinor int64

	// DeliverBy is per line: a hospital orders sutures and a capital item on
	// one order and expects them weeks apart.
	DeliverBy time.Time
	Notes     string
}

// StockQuantity is the line in the units stock is held in.
func (l POLine) StockQuantity() int {
	pack := l.PackSize
	if pack <= 0 {
		pack = 1
	}
	return l.Quantity * pack
}

// LineTotal is price times quantity, less discount, plus tax.
func (l POLine) LineTotal() Money {
	total := l.UnitPrice.Times(l.Quantity)
	total.Minor += l.TaxMinor - l.DiscountMinor
	return total
}

// PurchaseOrder is an order placed with a supplier (SRS-MAT-004).
//
// Versioned rather than edited. The acceptance is "PO version and amendments
// retained", and the reason is that a supplier delivers against the version
// they were sent: a quantity changed in place makes a correct delivery look
// like a short one, and there is then nothing to show which of the two
// parties was right.
type PurchaseOrder struct {
	ID       string
	TenantID string

	Number     string
	FacilityID string
	SupplierID string
	// RequisitionID and BidID are what this order came from. Carried so a
	// three-way match and a procurement audit can both run backwards.
	RequisitionID string
	BidID         string

	// Revision counts from one. Supersedes points at the version this
	// replaces, so the chain reads backwards.
	Revision   int
	Supersedes string
	// AmendmentReason is required on every revision after the first: an
	// amendment nobody explained is one nobody can defend when the invoice
	// arrives.
	AmendmentReason string

	Lines []POLine
	State POState

	Currency string
	// PaymentTermsDays and DeliveryTerms are the commercial terms that were
	// agreed, frozen on the order rather than read from the supplier master:
	// the master changes and this order did not.
	PaymentTermsDays int
	DeliveryTerms    string

	// ToleranceOverPercent and ToleranceShortPercent govern what a receipt
	// may differ by (SRS-MAT-005). On the order rather than global, because a
	// supplier who ships in cases has a different tolerance from one who
	// ships pieces.
	ToleranceOverPercent  int
	ToleranceShortPercent int

	IssuedAt  time.Time
	IssuedBy  string
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewPOInput places an order.
type NewPOInput struct {
	Number                string
	FacilityID            string
	SupplierID            string
	RequisitionID         string
	BidID                 string
	Lines                 []POLine
	Currency              string
	PaymentTermsDays      int
	DeliveryTerms         string
	ToleranceOverPercent  int
	ToleranceShortPercent int
}

// NewPurchaseOrder places an order with an approved supplier (SRS-MAT-004).
func NewPurchaseOrder(id, tenantID string, in NewPOInput, supplier Supplier,
	by string, now time.Time) (PurchaseOrder, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return PurchaseOrder{}, fmt.Errorf("%w: a purchase order needs an id",
			ErrInvalidMaterials)
	case !supplier.Approved:
		// The same rule the RFQ applies, at the point where money is
		// committed rather than where a question is asked.
		return PurchaseOrder{}, fmt.Errorf("%w: %s is not an approved supplier",
			ErrInvalidMaterials, supplier.Code)
	case strings.TrimSpace(by) == "":
		return PurchaseOrder{}, fmt.Errorf("%w: a purchase order names who raised it",
			ErrInvalidMaterials)
	case in.ToleranceOverPercent < 0 || in.ToleranceShortPercent < 0:
		return PurchaseOrder{}, fmt.Errorf("%w: a tolerance is not negative",
			ErrInvalidMaterials)
	}

	lines, err := checkedPOLines(in.Lines)
	if err != nil {
		return PurchaseOrder{}, err
	}

	currency := strings.TrimSpace(in.Currency)
	if currency == "" {
		currency = supplier.Currency
	}
	terms := in.PaymentTermsDays
	if terms == 0 {
		terms = supplier.PaymentTermsDays
	}

	return PurchaseOrder{
		ID: id, TenantID: tenantID,
		Number:        strings.TrimSpace(in.Number),
		FacilityID:    strings.TrimSpace(in.FacilityID),
		SupplierID:    supplier.ID,
		RequisitionID: strings.TrimSpace(in.RequisitionID),
		BidID:         strings.TrimSpace(in.BidID),
		Revision:      1,
		Lines:         lines, State: PODraft,
		Currency: currency, PaymentTermsDays: terms,
		DeliveryTerms:         strings.TrimSpace(in.DeliveryTerms),
		ToleranceOverPercent:  in.ToleranceOverPercent,
		ToleranceShortPercent: in.ToleranceShortPercent,
		CreatedAt:             now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

func checkedPOLines(in []POLine) ([]POLine, error) {
	if len(in) == 0 {
		return nil, fmt.Errorf("%w: a purchase order orders something",
			ErrInvalidMaterials)
	}
	seen := map[string]bool{}
	out := make([]POLine, 0, len(in))
	for _, line := range in {
		itemID := strings.TrimSpace(line.ItemID)
		switch {
		case itemID == "":
			return nil, fmt.Errorf("%w: an order line names its item",
				ErrInvalidMaterials)
		case seen[itemID]:
			return nil, fmt.Errorf("%w: %s appears twice on this order",
				ErrInvalidMaterials, line.ItemCode)
		case line.Quantity <= 0:
			return nil, fmt.Errorf("%w: %s is ordered with no quantity",
				ErrInvalidMaterials, line.ItemCode)
		case line.PackSize < 0:
			return nil, fmt.Errorf("%w: %s has a negative pack size",
				ErrInvalidMaterials, line.ItemCode)
		}
		seen[itemID] = true
		pack := line.PackSize
		if pack == 0 {
			pack = 1
		}
		out = append(out, POLine{
			ItemID: itemID, ItemCode: strings.TrimSpace(line.ItemCode),
			Quantity: line.Quantity, PackSize: pack,
			UOM:       strings.TrimSpace(line.UOM),
			UnitPrice: line.UnitPrice,
			TaxMinor:  line.TaxMinor, DiscountMinor: line.DiscountMinor,
			DeliverBy: line.DeliverBy.UTC(),
			Notes:     strings.TrimSpace(line.Notes),
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].ItemID < out[j].ItemID })
	return out, nil
}

// Total is the order's value.
func (p PurchaseOrder) Total() (Money, error) {
	total := Money{Currency: p.Currency}
	for _, line := range p.Lines {
		var err error
		total, err = total.Add(line.LineTotal())
		if err != nil {
			return Money{}, err
		}
	}
	return total, nil
}

// Issue sends an order to the supplier.
func (p *PurchaseOrder) Issue(by string, now time.Time) error {
	switch {
	case p.State != PODraft:
		return fmt.Errorf("%w: this order is %s", ErrInvalidMaterials, p.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: issuing an order names who did it",
			ErrInvalidMaterials)
	}
	p.State = POIssued
	p.IssuedAt, p.IssuedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// Amend produces the next revision (SRS-MAT-004).
//
// The earlier revision is not changed. A supplier delivers against the version
// they were sent, and a quantity edited in place makes a correct delivery look
// like a short one with nothing to show who was right.
func (p PurchaseOrder) Amend(id string, lines []POLine, reason, by string,
	now time.Time) (PurchaseOrder, error) {

	switch {
	case strings.TrimSpace(reason) == "":
		return PurchaseOrder{}, fmt.Errorf("%w: an amendment says why",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return PurchaseOrder{}, fmt.Errorf("%w: an amendment names who made it",
			ErrInvalidMaterials)
	case p.State == POClosed || p.State == POCancelled:
		return PurchaseOrder{}, fmt.Errorf("%w: this order is %s",
			ErrInvalidMaterials, p.State)
	}

	checked, err := checkedPOLines(lines)
	if err != nil {
		return PurchaseOrder{}, err
	}

	next := p
	next.ID = strings.TrimSpace(id)
	if next.ID == "" {
		return PurchaseOrder{}, fmt.Errorf("%w: an amendment needs an id",
			ErrInvalidMaterials)
	}
	next.Revision, next.Supersedes = p.Revision+1, p.ID
	next.AmendmentReason = strings.TrimSpace(reason)
	next.Lines = checked
	// An amended order is re-issued, so a supplier is never delivering
	// against a revision nobody sent them.
	next.State = PODraft
	next.IssuedAt, next.IssuedBy = time.Time{}, ""
	next.CreatedAt, next.CreatedBy = now.UTC(), strings.TrimSpace(by)
	next.Version = 1
	return next, nil
}

// Receipt is a goods receipt note against an order (SRS-MAT-005).
type Receipt struct {
	ID       string
	TenantID string

	Number          string
	PurchaseOrderID string
	// PORevision is the revision received against. A receipt that did not say
	// would be unresolvable the moment an order was amended.
	PORevision int
	SupplierID string
	LocationID string

	// DeliveryNote and Invoice are the supplier's own references, which is
	// what a three-way match joins on (SRS-MAT-014).
	DeliveryNote string
	InvoiceRef   string

	Lines []ReceiptLine

	ReceivedAt time.Time
	ReceivedBy string
	Version    int64
}

// ReceiptLine is one item received (SRS-MAT-005).
type ReceiptLine struct {
	ItemID   string
	ItemCode string
	// LotCode, Expiry and Serial identify what actually arrived, which is
	// never assumed from the order: the order says what was asked for.
	LotCode string
	Expiry  time.Time

	// QuantityOrdered is in stock units, carried so the discrepancy is
	// readable on the row rather than recomputed from the order.
	QuantityOrdered  int
	QuantityReceived int

	Ownership  Ownership
	SupplierID string

	Notes string
}

// Discrepancy is the difference between what was ordered and what arrived.
func (l ReceiptLine) Discrepancy() int {
	return l.QuantityReceived - l.QuantityOrdered
}

// ToleranceVerdict is what a discrepancy means (SRS-MAT-005).
type ToleranceVerdict string

const (
	WithinTolerance ToleranceVerdict = "within_tolerance"
	// OverTolerance is more than the order allows. Refused rather than
	// recorded: unordered stock accepted into the ledger is stock somebody
	// will be invoiced for.
	OverTolerance ToleranceVerdict = "over_tolerance"
	// ShortBeyondTolerance is recorded, not refused. The goods are on the
	// dock whatever the count says, and refusing the receipt would leave them
	// in the ledger as never having arrived.
	ShortBeyondTolerance ToleranceVerdict = "short_beyond_tolerance"
)

// CheckTolerance judges one line against the order's rules (SRS-MAT-005).
func CheckTolerance(line ReceiptLine, order PurchaseOrder) ToleranceVerdict {
	if line.QuantityOrdered <= 0 {
		// Nothing was ordered, so any quantity is over.
		if line.QuantityReceived > 0 {
			return OverTolerance
		}
		return WithinTolerance
	}

	difference := line.Discrepancy()
	if difference == 0 {
		return WithinTolerance
	}
	if difference > 0 {
		allowed := line.QuantityOrdered * order.ToleranceOverPercent / 100
		if difference <= allowed {
			return WithinTolerance
		}
		return OverTolerance
	}
	allowed := line.QuantityOrdered * order.ToleranceShortPercent / 100
	if -difference <= allowed {
		return WithinTolerance
	}
	return ShortBeyondTolerance
}

// NewReceiptInput records a delivery.
type NewReceiptInput struct {
	Number       string
	LocationID   string
	DeliveryNote string
	InvoiceRef   string
	Lines        []ReceiptLine
}

// NewReceipt records a delivery against an order (SRS-MAT-005).
//
// Over-receipt beyond tolerance is refused; short receipt beyond tolerance is
// recorded and reported. The asymmetry is deliberate and it is the whole of
// "over/short receipt follows tolerance rules": accepting stock nobody ordered
// puts it in the ledger and on an invoice, while refusing to record a short
// delivery leaves goods on the dock that the system says never came.
func NewReceipt(id, tenantID string, in NewReceiptInput, order PurchaseOrder,
	items map[string]Item, by string, now time.Time) (
	Receipt, []string, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Receipt{}, nil, fmt.Errorf("%w: a receipt needs an id",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.LocationID) == "":
		// Stock that arrived nowhere cannot be found, picked or counted.
		return Receipt{}, nil, fmt.Errorf("%w: a receipt names the store it came into",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Receipt{}, nil, fmt.Errorf("%w: a receipt names who took it in",
			ErrInvalidMaterials)
	case order.State == POCancelled:
		return Receipt{}, nil, fmt.Errorf("%w: this order was cancelled",
			ErrInvalidMaterials)
	case order.State == PODraft:
		// A delivery against an order the supplier was never sent is a
		// delivery against somebody else's order.
		return Receipt{}, nil, fmt.Errorf("%w: this order has not been issued",
			ErrInvalidMaterials)
	case len(in.Lines) == 0:
		return Receipt{}, nil, fmt.Errorf("%w: a receipt records something arriving",
			ErrInvalidMaterials)
	}

	ordered := make(map[string]POLine, len(order.Lines))
	for _, line := range order.Lines {
		ordered[line.ItemID] = line
	}

	var short []string
	lines := make([]ReceiptLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		itemID := strings.TrimSpace(line.ItemID)
		poLine, onOrder := ordered[itemID]
		if !onOrder {
			// An item not on the order is not a discrepancy to be recorded:
			// it is a different delivery, and putting it in this receipt
			// would attach it to this order's invoice.
			return Receipt{}, nil, fmt.Errorf("%w: %s is not on this order",
				ErrInvalidMaterials, line.ItemCode)
		}
		item, known := items[itemID]
		if !known {
			return Receipt{}, nil, fmt.Errorf("%w: no such item",
				ErrInvalidMaterials)
		}
		if line.QuantityReceived <= 0 {
			return Receipt{}, nil, fmt.Errorf("%w: %s arrived with no quantity",
				ErrInvalidMaterials, item.Code)
		}
		if item.Tracking.RequiresLot() && strings.TrimSpace(line.LotCode) == "" {
			return Receipt{}, nil, fmt.Errorf(
				"%w: %s is tracked by %s; record what arrived",
				ErrInvalidMaterials, item.Code, item.Tracking)
		}
		if item.Perishable && line.Expiry.IsZero() {
			return Receipt{}, nil, fmt.Errorf("%w: %s expires; record when",
				ErrInvalidMaterials, item.Code)
		}

		checked := ReceiptLine{
			ItemID: itemID, ItemCode: item.Code,
			LotCode: strings.TrimSpace(line.LotCode), Expiry: line.Expiry.UTC(),
			QuantityOrdered:  poLine.StockQuantity(),
			QuantityReceived: line.QuantityReceived,
			Ownership:        line.Ownership,
			SupplierID:       strings.TrimSpace(line.SupplierID),
			Notes:            strings.TrimSpace(line.Notes),
		}
		if checked.Ownership == "" {
			checked.Ownership = OwnedByHospital
		}
		if checked.Ownership == OwnedConsignment && checked.SupplierID == "" {
			checked.SupplierID = order.SupplierID
		}

		switch CheckTolerance(checked, order) {
		case OverTolerance:
			return Receipt{}, nil, fmt.Errorf(
				"%w: %s: %d received against %d ordered is more than the "+
					"%d%% this order allows", ErrInvalidMaterials, item.Code,
				checked.QuantityReceived, checked.QuantityOrdered,
				order.ToleranceOverPercent)
		case ShortBeyondTolerance:
			short = append(short, fmt.Sprintf("%s: %d of %d",
				item.Code, checked.QuantityReceived, checked.QuantityOrdered))
		}
		lines = append(lines, checked)
	}
	sort.Slice(lines, func(i, j int) bool { return lines[i].ItemID < lines[j].ItemID })
	sort.Strings(short)

	return Receipt{
		ID: id, TenantID: tenantID,
		Number:          strings.TrimSpace(in.Number),
		PurchaseOrderID: order.ID, PORevision: order.Revision,
		SupplierID:   order.SupplierID,
		LocationID:   strings.TrimSpace(in.LocationID),
		DeliveryNote: strings.TrimSpace(in.DeliveryNote),
		InvoiceRef:   strings.TrimSpace(in.InvoiceRef),
		Lines:        lines,
		ReceivedAt:   now.UTC(), ReceivedBy: strings.TrimSpace(by),
		Version: 1,
	}, short, nil
}

// LandingStatus is the status received stock lands in (SRS-MAT-006).
//
// The one place that decides. An item configured for inspection lands in
// quarantine, everything else lands available, and SRS-MAT-006's "unaccepted
// stock cannot become available" is then a property of where it went rather
// than a check somebody has to remember.
func LandingStatus(item Item) StockStatus {
	if item.InspectOnReceipt {
		return StatusQuarantine
	}
	return StatusAvailable
}
