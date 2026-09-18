package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// TransferState is where a transfer between stores has got to (SRS-MAT-010).
type TransferState string

const (
	// TransferInTransit is dispatched and not yet received. The state that
	// exists so nothing is ever nowhere: the quantity sits in an in-transit
	// bucket, counted, and both stores' balances reconcile against it.
	TransferInTransit TransferState = "in_transit"
	TransferReceived  TransferState = "received"
	// TransferCancelled returns the stock to the source. Distinct from
	// received, because the goods came back rather than arrived.
	TransferCancelled TransferState = "cancelled"
)

// TransferLine is one item moved between stores.
type TransferLine struct {
	ItemID   string
	LotID    string
	Quantity int
	// QuantityReceived is what the destination actually counted in. Short
	// arrival is recorded, not refused: the difference is what an
	// investigation starts from, and refusing would leave it unwritten.
	QuantityReceived int
}

// Transfer moves stock between stores (SRS-MAT-010).
type Transfer struct {
	ID       string
	TenantID string

	Number       string
	FromLocation string
	ToLocation   string
	Lines        []TransferLine
	State        TransferState

	Reason string

	DispatchedAt time.Time
	DispatchedBy string
	ReceivedAt   time.Time
	ReceivedBy   string
	Version      int64
}

// NewTransferInput dispatches a transfer.
type NewTransferInput struct {
	Number       string
	FromLocation string
	ToLocation   string
	Lines        []TransferLine
	Reason       string
}

// NewTransfer dispatches stock to another store (SRS-MAT-010).
func NewTransfer(id, tenantID string, in NewTransferInput, by string,
	now time.Time) (Transfer, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Transfer{}, fmt.Errorf("%w: a transfer needs an id",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.FromLocation) == "":
		return Transfer{}, fmt.Errorf("%w: a transfer names where it left",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.ToLocation) == "":
		return Transfer{}, fmt.Errorf("%w: a transfer names where it is going",
			ErrInvalidMaterials)
	case in.FromLocation == in.ToLocation:
		// A transfer to itself moves nothing and would leave a quantity in
		// transit that nobody is waiting for.
		return Transfer{}, fmt.Errorf("%w: a transfer goes somewhere else",
			ErrInvalidMaterials)
	case len(in.Lines) == 0:
		return Transfer{}, fmt.Errorf("%w: a transfer moves something",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Transfer{}, fmt.Errorf("%w: a transfer names who dispatched it",
			ErrInvalidMaterials)
	}

	lines := make([]TransferLine, 0, len(in.Lines))
	seen := map[string]bool{}
	for _, line := range in.Lines {
		key := line.ItemID + "/" + line.LotID
		switch {
		case strings.TrimSpace(line.ItemID) == "" ||
			strings.TrimSpace(line.LotID) == "":
			return Transfer{}, fmt.Errorf("%w: a transfer line names its item and lot",
				ErrInvalidMaterials)
		case line.Quantity <= 0:
			return Transfer{}, fmt.Errorf("%w: a transfer line moves a quantity",
				ErrInvalidMaterials)
		case seen[key]:
			return Transfer{}, fmt.Errorf("%w: a lot appears twice on this transfer",
				ErrInvalidMaterials)
		}
		seen[key] = true
		lines = append(lines, TransferLine{
			ItemID: strings.TrimSpace(line.ItemID),
			LotID:  strings.TrimSpace(line.LotID), Quantity: line.Quantity,
		})
	}
	sort.Slice(lines, func(i, j int) bool {
		if lines[i].ItemID != lines[j].ItemID {
			return lines[i].ItemID < lines[j].ItemID
		}
		return lines[i].LotID < lines[j].LotID
	})

	return Transfer{
		ID: id, TenantID: tenantID,
		Number:       strings.TrimSpace(in.Number),
		FromLocation: strings.TrimSpace(in.FromLocation),
		ToLocation:   strings.TrimSpace(in.ToLocation),
		Lines:        lines, State: TransferInTransit,
		Reason:       strings.TrimSpace(in.Reason),
		DispatchedAt: now.UTC(), DispatchedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Receive closes a transfer at the destination (SRS-MAT-010).
//
// Returns what arrived short. Recorded rather than refused: the stock is on
// the destination's counter whatever the count says, and the difference is
// what an investigation starts from.
func (t *Transfer) Receive(counted map[string]int, by string,
	now time.Time) ([]string, error) {

	switch {
	case t.State != TransferInTransit:
		return nil, fmt.Errorf("%w: this transfer is %s", ErrInvalidMaterials, t.State)
	case strings.TrimSpace(by) == "":
		return nil, fmt.Errorf("%w: receiving a transfer names who did it",
			ErrInvalidMaterials)
	}

	var short []string
	for i := range t.Lines {
		key := t.Lines[i].ItemID + "/" + t.Lines[i].LotID
		received, told := counted[key]
		if !told {
			// Silence means everything arrived. A count that has to be
			// retyped line by line is a count nobody does, and the failure
			// mode of assuming zero is a store that writes off a full pallet.
			received = t.Lines[i].Quantity
		}
		if received < 0 || received > t.Lines[i].Quantity {
			return nil, fmt.Errorf(
				"%w: %d received against %d dispatched is not a count",
				ErrInvalidMaterials, received, t.Lines[i].Quantity)
		}
		t.Lines[i].QuantityReceived = received
		if received < t.Lines[i].Quantity {
			short = append(short, fmt.Sprintf("%s: %d of %d",
				t.Lines[i].ItemID, received, t.Lines[i].Quantity))
		}
	}
	sort.Strings(short)

	t.State = TransferReceived
	t.ReceivedAt, t.ReceivedBy = now.UTC(), strings.TrimSpace(by)
	return short, nil
}

// CountState is where a stocktake has got to (SRS-MAT-011).
type CountState string

const (
	CountOpen     CountState = "open"
	CountCounted  CountState = "counted"
	CountApproved CountState = "approved"
	CountRejected CountState = "rejected"
)

// CountLine is one item counted.
type CountLine struct {
	ItemID string
	LotID  string
	// Expected is what the ledger said at the moment the count was taken,
	// frozen. Recomputing it at approval would compare the shelf against a
	// balance that has moved since, and the variance would be somebody
	// else's issue.
	Expected int
	Counted  int
	Reason   string
}

// Variance is the difference the adjustment would post.
func (l CountLine) Variance() int { return l.Counted - l.Expected }

// Count is a cycle or physical count (SRS-MAT-011).
type Count struct {
	ID       string
	TenantID string

	Number     string
	LocationID string
	// Cycle marks a rolling count of part of the store, as opposed to a full
	// physical count. Both post adjustments the same way; the distinction is
	// what a NABH auditor asks about.
	Cycle bool

	Lines []CountLine
	State CountState

	// ApprovedBy is required before any adjustment is posted, and it is not
	// the counter: SRS-MAT-011's "variance adjustment requires
	// approval/reason" is exactly the control that the person who counted
	// does not also sign off what the count changed.
	ApprovedBy   string
	ApprovedAt   time.Time
	ApprovalNote string

	OpenedAt  time.Time
	OpenedBy  string
	CountedAt time.Time
	CountedBy string
	Version   int64
}

// NewCountInput opens a stocktake.
type NewCountInput struct {
	Number     string
	LocationID string
	Cycle      bool
	Lines      []CountLine
}

// NewCount opens a stocktake (SRS-MAT-011).
func NewCount(id, tenantID string, in NewCountInput, by string,
	now time.Time) (Count, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Count{}, fmt.Errorf("%w: a count needs an id", ErrInvalidMaterials)
	case strings.TrimSpace(in.LocationID) == "":
		return Count{}, fmt.Errorf("%w: a count names the store it is of",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Count{}, fmt.Errorf("%w: a count names who opened it",
			ErrInvalidMaterials)
	}

	return Count{
		ID: id, TenantID: tenantID,
		Number:     strings.TrimSpace(in.Number),
		LocationID: strings.TrimSpace(in.LocationID), Cycle: in.Cycle,
		Lines: in.Lines, State: CountOpen,
		OpenedAt: now.UTC(), OpenedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Record enters what was on the shelf (SRS-MAT-011).
func (c *Count) Record(lines []CountLine, by string, now time.Time) error {
	switch {
	case c.State != CountOpen:
		return fmt.Errorf("%w: this count is %s", ErrInvalidMaterials, c.State)
	case len(lines) == 0:
		return fmt.Errorf("%w: a count records something", ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a count names who counted", ErrInvalidMaterials)
	}

	seen := map[string]bool{}
	checked := make([]CountLine, 0, len(lines))
	for _, line := range lines {
		key := line.ItemID + "/" + line.LotID
		switch {
		case strings.TrimSpace(line.ItemID) == "" ||
			strings.TrimSpace(line.LotID) == "":
			return fmt.Errorf("%w: a count line names its item and lot",
				ErrInvalidMaterials)
		case seen[key]:
			return fmt.Errorf("%w: a lot is counted twice", ErrInvalidMaterials)
		case line.Counted < 0:
			return fmt.Errorf("%w: a count is not negative", ErrInvalidMaterials)
		}
		seen[key] = true
		checked = append(checked, CountLine{
			ItemID:   strings.TrimSpace(line.ItemID),
			LotID:    strings.TrimSpace(line.LotID),
			Expected: line.Expected, Counted: line.Counted,
			Reason: strings.TrimSpace(line.Reason),
		})
	}
	sort.Slice(checked, func(i, j int) bool {
		if checked[i].ItemID != checked[j].ItemID {
			return checked[i].ItemID < checked[j].ItemID
		}
		return checked[i].LotID < checked[j].LotID
	})

	c.Lines = checked
	c.State = CountCounted
	c.CountedAt, c.CountedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// Variances are the lines that differ.
func (c Count) Variances() []CountLine {
	var out []CountLine
	for _, line := range c.Lines {
		if line.Variance() != 0 {
			out = append(out, line)
		}
	}
	return out
}

// Approve authorises the adjustments a count would post (SRS-MAT-011).
//
// The approver is not the counter. That is the whole control: a storekeeper
// who could count their own store and sign off the difference can make any
// shortfall disappear, and the variance report is then a record of nothing.
func (c *Count) Approve(by, note string, now time.Time) error {
	switch {
	case c.State != CountCounted:
		return fmt.Errorf("%w: this count is %s", ErrInvalidMaterials, c.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidMaterials)
	case strings.TrimSpace(by) == c.CountedBy:
		return fmt.Errorf(
			"%w: the person who counted does not approve the adjustment",
			ErrInvalidMaterials)
	}

	// Every variance needs a reason before it is posted. A count that moved
	// the ledger for reasons nobody wrote down is a count that will be
	// repeated next quarter with the same result.
	var unexplained []string
	for _, line := range c.Variances() {
		if line.Reason == "" {
			unexplained = append(unexplained, line.ItemID)
		}
	}
	if len(unexplained) > 0 {
		return fmt.Errorf("%w: %d variance(s) have no reason recorded",
			ErrInvalidMaterials, len(unexplained))
	}

	c.State = CountApproved
	c.ApprovedBy, c.ApprovedAt = strings.TrimSpace(by), now.UTC()
	c.ApprovalNote = strings.TrimSpace(note)
	return nil
}

// Reject ends a count without posting anything.
func (c *Count) Reject(by, note string, now time.Time) error {
	switch {
	case c.State != CountCounted:
		return fmt.Errorf("%w: this count is %s", ErrInvalidMaterials, c.State)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: a rejected count says why", ErrInvalidMaterials)
	}
	c.State = CountRejected
	c.ApprovedBy, c.ApprovedAt = strings.TrimSpace(by), now.UTC()
	c.ApprovalNote = strings.TrimSpace(note)
	return nil
}

// AlertKind is what a stock alert is about (SRS-MAT-012).
type AlertKind string

const (
	AlertStockout     AlertKind = "stockout"
	AlertBelowMinimum AlertKind = "below_minimum"
	// AlertExpiringSoon is stock that will be wasted unless it is used.
	AlertExpiringSoon AlertKind = "expiring_soon"
	AlertExpired      AlertKind = "expired"
)

// Alert is one thing a storekeeper should look at.
type Alert struct {
	Kind       AlertKind
	ItemID     string
	LocationID string
	LotID      string

	Available int
	Minimum   int
	// SuggestedOrder is what a top-up would order. Reviewable before it
	// becomes a requisition, which is SRS-MAT-012's acceptance: a system that
	// raised the order itself would buy what its own arithmetic decided.
	SuggestedOrder int
	Expiry         time.Time
	Detail         string
}

// StockAlerts derives what needs attention (SRS-MAT-012).
//
// Derived on read, never stored. A stored alert is one that stays raised after
// the stock arrives, and a storekeeper who has learned to ignore stale alerts
// ignores the real one too.
//
// A level nobody configured raises nothing. Not every store carries every
// item, and an alert on all of them is an alert on none.
func StockAlerts(levels []StockLevel, balances []Balance, lots map[string]Lot,
	expiryHorizon time.Duration, now time.Time) []Alert {

	var out []Alert

	for _, level := range levels {
		if level.Minimum <= 0 {
			continue
		}
		available := Available(balances, lots, level.ItemID, level.LocationID, now)
		if available > level.Minimum {
			continue
		}

		kind := AlertBelowMinimum
		if available <= 0 {
			kind = AlertStockout
		}
		suggested := level.ReorderQuantity
		if suggested <= 0 {
			suggested = level.Maximum - available
		}
		if suggested < 0 {
			suggested = 0
		}
		out = append(out, Alert{
			Kind: kind, ItemID: level.ItemID, LocationID: level.LocationID,
			Available: available, Minimum: level.Minimum,
			SuggestedOrder: suggested,
		})
	}

	if expiryHorizon > 0 {
		horizon := now.Add(expiryHorizon)
		for _, balance := range balances {
			if balance.Quantity <= 0 || !balance.Bucket.Inside() {
				continue
			}
			lot, known := lots[balance.LotID]
			if !known || lot.Expiry.IsZero() {
				continue
			}
			switch {
			case lot.Expired(now):
				out = append(out, Alert{
					Kind: AlertExpired, ItemID: balance.ItemID,
					LocationID: balance.Bucket.LocationID, LotID: lot.ID,
					Available: balance.Quantity, Expiry: lot.Expiry,
					Detail: "expired on " + lot.Expiry.Format("2006-01-02"),
				})
			case lot.Expiry.Before(horizon):
				out = append(out, Alert{
					Kind: AlertExpiringSoon, ItemID: balance.ItemID,
					LocationID: balance.Bucket.LocationID, LotID: lot.ID,
					Available: balance.Quantity, Expiry: lot.Expiry,
					Detail: "expires on " + lot.Expiry.Format("2006-01-02"),
				})
			}
		}
	}

	sort.Slice(out, func(i, j int) bool {
		if out[i].Kind != out[j].Kind {
			return out[i].Kind < out[j].Kind
		}
		if out[i].ItemID != out[j].ItemID {
			return out[i].ItemID < out[j].ItemID
		}
		return out[i].LocationID < out[j].LocationID
	})
	return out
}

// MatchStatus is what a three-way match found (SRS-MAT-014).
type MatchStatus string

const (
	MatchOK MatchStatus = "matched"
	// MatchQuantity is a quantity that differs between order, receipt and
	// invoice.
	MatchQuantity MatchStatus = "quantity_mismatch"
	// MatchPrice is a price that differs from the order.
	MatchPrice MatchStatus = "price_mismatch"
	// MatchMissing is an invoice line with no receipt, or a receipt with no
	// invoice.
	MatchMissing MatchStatus = "missing_document"
)

// InvoiceLine is one line of a supplier's invoice (SRS-MAT-014).
type InvoiceLine struct {
	ItemID string
	// Quantity is in stock units, converted on the way in so the three
	// documents are compared in one unit.
	Quantity  int
	UnitPrice Money
	TaxMinor  int64
}

// Invoice is a supplier's bill (SRS-MAT-014).
type Invoice struct {
	ID       string
	TenantID string

	Number          string
	SupplierID      string
	PurchaseOrderID string
	Lines           []InvoiceLine
	Currency        string

	ReceivedAt time.Time
	RecordedBy string
}

// MatchLine is one item's verdict across the three documents.
type MatchLine struct {
	ItemID string
	Status MatchStatus

	Ordered  int
	Received int
	Invoiced int

	OrderedUnitMinor  int64
	InvoicedUnitMinor int64

	Detail string
}

// MatchResult is the whole comparison.
type MatchResult struct {
	PurchaseOrderID string
	InvoiceID       string
	Lines           []MatchLine
	// Matched is true only when every line matched. A partial match is not a
	// match: the whole point is that one wrong line stops the payment.
	Matched bool
}

// ThreeWayMatch compares order, receipts and invoice (SRS-MAT-014).
//
// Surfaces mismatches; it does not resolve them. The acceptance is "mismatch
// is surfaced for resolution", and the reason is that the resolution is a
// human negotiation — a credit note, a short-shipment agreed by phone — and a
// system that silently picked one of the three numbers would pay the wrong
// one.
//
// Every line of all three documents appears, including the ones present in
// only one. An invoice line with no receipt is the most common fraud and the
// most common typo, and leaving it out of the comparison is how both survive.
func ThreeWayMatch(order PurchaseOrder, receipts []Receipt,
	invoice Invoice) MatchResult {

	ordered := map[string]POLine{}
	for _, line := range order.Lines {
		ordered[line.ItemID] = line
	}
	received := map[string]int{}
	for _, receipt := range receipts {
		for _, line := range receipt.Lines {
			received[line.ItemID] += line.QuantityReceived
		}
	}
	invoiced := map[string]InvoiceLine{}
	for _, line := range invoice.Lines {
		existing := invoiced[line.ItemID]
		existing.ItemID = line.ItemID
		existing.Quantity += line.Quantity
		// The unit price of the last line wins for reporting; a mismatch
		// between two lines of one invoice for one item shows up as a
		// quantity or price difference against the order either way.
		existing.UnitPrice = line.UnitPrice
		existing.TaxMinor += line.TaxMinor
		invoiced[line.ItemID] = existing
	}

	items := map[string]bool{}
	for itemID := range ordered {
		items[itemID] = true
	}
	for itemID := range received {
		items[itemID] = true
	}
	for itemID := range invoiced {
		items[itemID] = true
	}

	result := MatchResult{
		PurchaseOrderID: order.ID, InvoiceID: invoice.ID, Matched: true,
	}
	for itemID := range items {
		poLine, onOrder := ordered[itemID]
		invoiceLine, onInvoice := invoiced[itemID]
		receivedQty := received[itemID]

		line := MatchLine{
			ItemID: itemID, Status: MatchOK,
			Received: receivedQty, Invoiced: invoiceLine.Quantity,
			InvoicedUnitMinor: invoiceLine.UnitPrice.Minor,
		}
		if onOrder {
			line.Ordered = poLine.StockQuantity()
			// The order's price is per purchase unit; the comparison is per
			// stock unit, which is the conversion an invoice check gets
			// wrong when it is done by eye.
			pack := poLine.PackSize
			if pack <= 0 {
				pack = 1
			}
			line.OrderedUnitMinor = poLine.UnitPrice.Minor / int64(pack)
		}

		switch {
		case !onOrder:
			line.Status = MatchMissing
			line.Detail = "invoiced or received but never ordered"
		case !onInvoice && receivedQty > 0:
			line.Status = MatchMissing
			line.Detail = "received but not invoiced"
		case onInvoice && receivedQty == 0:
			line.Status = MatchMissing
			line.Detail = "invoiced but nothing was received"
		case onInvoice && invoiceLine.Quantity != receivedQty:
			line.Status = MatchQuantity
			line.Detail = fmt.Sprintf("invoiced %d, received %d",
				invoiceLine.Quantity, receivedQty)
		case onInvoice && line.OrderedUnitMinor != line.InvoicedUnitMinor:
			line.Status = MatchPrice
			line.Detail = fmt.Sprintf("ordered at %d, invoiced at %d per unit",
				line.OrderedUnitMinor, line.InvoicedUnitMinor)
		}
		if line.Status != MatchOK {
			result.Matched = false
		}
		result.Lines = append(result.Lines, line)
	}

	sort.Slice(result.Lines, func(i, j int) bool {
		return result.Lines[i].ItemID < result.Lines[j].ItemID
	})
	return result
}
