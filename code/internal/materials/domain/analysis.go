package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// LiabilityEvent is what consuming consignment stock raises (SRS-MAT-016).
//
// The requirement's clause is that "consumption triggers contractually defined
// charge/liability event", and this is the liability half: the moment the
// hospital used the supplier's implant, it owes for it. The charge half is
// SRS-BIL's, reached through a port, because a hospital has one place that
// decides what a patient is charged and this is not it.
type LiabilityEvent struct {
	ID       string
	TenantID string

	LotID      string
	ItemID     string
	SupplierID string
	Quantity   int

	// PatientID and EncounterID are why a consignment implant is different
	// from a consignment box of gloves: the supplier invoices against the
	// case, and the hospital charges against the patient.
	PatientID   string
	EncounterID string
	MovementID  string

	OccurredAt time.Time
	RecordedBy string
}

// Consume records stock used, and says what it owes (SRS-MAT-008,
// SRS-MAT-016).
//
// Returns the movement and, for consignment stock, the liability it raised.
// One function rather than two, because the two must not be able to come
// apart: consignment stock consumed without a liability is an implant the
// hospital used and nobody will ever invoice for, and that is the error this
// requirement exists to prevent.
func Consume(movementID, liabilityID, tenantID string, lot Lot, item Item,
	from Bucket, quantity int, patientID, encounterID, costCentre,
	reference, by string, now time.Time) (Movement, *LiabilityEvent, error) {

	switch {
	case !from.Issuable():
		// Consuming from quarantine would be using stock nobody accepted,
		// and consuming from in-transit would be using stock that is on a
		// trolley somewhere.
		return Movement{}, nil, fmt.Errorf(
			"%w: stock is consumed from available stock, not from %s",
			ErrInvalidMaterials, from.Status)
	case !lot.Issuable(now):
		reason := "expired"
		if lot.Blocked {
			reason = "blocked: " + lot.BlockedReason
		}
		return Movement{}, nil, fmt.Errorf("%w: %s is %s",
			ErrInvalidMaterials, lotLabel(lot), reason)
	case item.Tracking == TrackingSerial && quantity != 1:
		// A serial identifies one object. Consuming two of it is consuming
		// something that does not exist.
		return Movement{}, nil, fmt.Errorf(
			"%w: %s is tracked by serial; one at a time",
			ErrInvalidMaterials, item.Code)
	}

	movement, err := NewMovement(movementID, tenantID, NewMovementInput{
		ItemID: lot.ItemID, LotID: lot.ID,
		From: from, To: Outside, Quantity: quantity,
		Kind: MovementConsumption, Reference: reference,
		CostCentre: costCentre, PatientID: patientID, EncounterID: encounterID,
	}, by, now)
	if err != nil {
		return Movement{}, nil, err
	}

	if lot.Ownership != OwnedConsignment {
		return movement, nil, nil
	}

	if strings.TrimSpace(liabilityID) == "" {
		return Movement{}, nil, fmt.Errorf("%w: a liability event needs an id",
			ErrInvalidMaterials)
	}
	return movement, &LiabilityEvent{
		ID: strings.TrimSpace(liabilityID), TenantID: tenantID,
		LotID: lot.ID, ItemID: lot.ItemID, SupplierID: lot.SupplierID,
		Quantity:    quantity,
		PatientID:   strings.TrimSpace(patientID),
		EncounterID: strings.TrimSpace(encounterID),
		MovementID:  movement.ID,
		OccurredAt:  now.UTC(), RecordedBy: strings.TrimSpace(by),
	}, nil
}

// Metrics are the inventory KPIs (SRS-MAT-015).
//
// Every figure is derived from the ledger and the orders at the moment it is
// asked for. The acceptance is "KPI formulas are reproducible from ledger/PO
// data", and a stored KPI is by construction not reproducible: it is whatever
// the job that wrote it computed, from data that has since changed.
//
// The formulas are stated in the comments rather than only in the code,
// because a KPI nobody can restate is a KPI a board meeting argues about.
type Metrics struct {
	ItemID     string
	LocationID string
	From       time.Time
	To         time.Time

	// ConsumedUnits is what left for patients and departments in the period.
	ConsumedUnits int
	// AverageOnHand is the mean of opening and closing on-hand. A crude mean
	// and deliberately so: the alternative needs a balance per day, and a
	// figure whose method nobody can restate is worse than a rough one whose
	// method is one line.
	AverageOnHand int
	ClosingOnHand int
	OpeningOnHand int

	// TurnsPerYear is consumption annualised over average on-hand. Zero when
	// nothing was held, because dividing by no stock is not an infinite turn
	// rate: it is a period with nothing to measure.
	TurnsPerYear float64
	// DaysOnHand is closing stock divided by the daily consumption rate.
	// Zero consumption gives zero rather than infinity, and the caller reads
	// it alongside ClosingOnHand rather than as "we will run out today".
	DaysOnHand float64

	// ExpiryExposureUnits is stock on hand that expires within the horizon:
	// what the hospital will throw away unless it is used.
	ExpiryExposureUnits int

	// Incomplete names what a figure could not be built from, so a reader
	// can tell a real zero from a gap.
	Incomplete []string
}

// MetricsInput is what the KPIs are computed from.
type MetricsInput struct {
	ItemID     string
	LocationID string
	From       time.Time
	To         time.Time
	// Movements are every movement touching the item, in any period: the
	// opening balance is derived by replaying those before From.
	Movements     []Movement
	Lots          map[string]Lot
	ExpiryHorizon time.Duration
}

// ComputeMetrics derives the inventory KPIs (SRS-MAT-015).
func ComputeMetrics(in MetricsInput) Metrics {
	out := Metrics{
		ItemID: in.ItemID, LocationID: in.LocationID,
		From: in.From.UTC(), To: in.To.UTC(),
	}
	if !in.From.Before(in.To) {
		out.Incomplete = append(out.Incomplete,
			"the period has no length, so nothing could be measured")
		return out
	}

	var before, upToEnd []Movement
	for _, m := range in.Movements {
		if m.ItemID != in.ItemID {
			continue
		}
		switch {
		case m.OccurredAt.Before(in.From):
			before = append(before, m)
			upToEnd = append(upToEnd, m)
		case m.OccurredAt.Before(in.To):
			upToEnd = append(upToEnd, m)
			if m.Kind == MovementConsumption || m.Kind == MovementIssue {
				if m.From.LocationID == in.LocationID {
					out.ConsumedUnits += m.Quantity
				}
			}
		}
	}

	out.OpeningOnHand = OnHand(Balances(before), in.ItemID, in.LocationID)
	closing := Balances(upToEnd)
	out.ClosingOnHand = OnHand(closing, in.ItemID, in.LocationID)
	out.AverageOnHand = (out.OpeningOnHand + out.ClosingOnHand) / 2

	days := in.To.Sub(in.From).Hours() / 24
	if days > 0 && out.AverageOnHand > 0 {
		// turns/year = consumption / average on-hand, scaled from the period
		// to a year.
		out.TurnsPerYear = float64(out.ConsumedUnits) /
			float64(out.AverageOnHand) * (365 / days)
	}
	if days > 0 && out.ConsumedUnits > 0 {
		// days on hand = closing stock / (consumption per day).
		perDay := float64(out.ConsumedUnits) / days
		out.DaysOnHand = float64(out.ClosingOnHand) / perDay
	}
	// A store cannot hold less than nothing. A negative balance means the
	// ledger is missing its receipts — stock issued from a location it was
	// never received into — and every figure derived from it is arithmetic
	// over an impossibility. Said plainly rather than reported as a turn
	// rate: the number would look like a busy store.
	if out.OpeningOnHand < 0 || out.ClosingOnHand < 0 {
		out.Incomplete = append(out.Incomplete,
			"this location holds a negative balance, so its receipts are "+
				"missing and no figure here can be trusted")
	} else if out.AverageOnHand == 0 && out.ConsumedUnits > 0 {
		out.Incomplete = append(out.Incomplete,
			"stock was consumed but none was ever received here, so turns "+
				"and days-on-hand cannot be computed")
	}

	if in.ExpiryHorizon > 0 {
		horizon := in.To.Add(in.ExpiryHorizon)
		for _, balance := range closing {
			if balance.ItemID != in.ItemID ||
				balance.Bucket.LocationID != in.LocationID ||
				balance.Quantity <= 0 {
				continue
			}
			lot, known := in.Lots[balance.LotID]
			if !known {
				out.Incomplete = append(out.Incomplete,
					"a lot with no record was left out of the expiry exposure")
				continue
			}
			if !lot.Expiry.IsZero() && lot.Expiry.Before(horizon) {
				out.ExpiryExposureUnits += balance.Quantity
			}
		}
	}

	out.Incomplete = sortedCodes(out.Incomplete)
	return out
}

// SupplierFillRate is how much of what was ordered actually arrived
// (SRS-MAT-015).
type SupplierFillRate struct {
	SupplierID string
	From       time.Time
	To         time.Time

	OrderedUnits  int
	ReceivedUnits int
	// FillRate is received over ordered, as a fraction. Capped at one:
	// an over-delivery within tolerance is not a supplier who filled more
	// than they were asked for, and letting one line above one lift the
	// average would hide a short delivery on another.
	FillRate float64

	// OnTimeLines and LateLines count against the line's own delivery date,
	// because an order with one capital item and one box of gloves has two
	// different promises on it.
	OnTimeLines int
	LateLines   int

	Incomplete []string
}

// ComputeFillRate derives a supplier's fill rate (SRS-MAT-015).
func ComputeFillRate(supplierID string, from, to time.Time,
	orders []PurchaseOrder, receipts []Receipt) SupplierFillRate {

	out := SupplierFillRate{SupplierID: supplierID, From: from.UTC(), To: to.UTC()}

	// Only the revision actually delivered against counts. Totalling every
	// revision would count an amended order twice and make a supplier who
	// filled it perfectly look half as good.
	live := map[string]PurchaseOrder{}
	for _, order := range orders {
		if order.SupplierID != supplierID || order.State == POCancelled {
			continue
		}
		if order.IssuedAt.Before(from) || !order.IssuedAt.Before(to) {
			continue
		}
		live[order.ID] = order
	}

	receivedByOrderItem := map[string]int{}
	receivedAt := map[string]time.Time{}
	for _, receipt := range receipts {
		if receipt.SupplierID != supplierID {
			continue
		}
		if _, ours := live[receipt.PurchaseOrderID]; !ours {
			continue
		}
		for _, line := range receipt.Lines {
			key := receipt.PurchaseOrderID + "/" + line.ItemID
			receivedByOrderItem[key] += line.QuantityReceived
			if existing, seen := receivedAt[key]; !seen ||
				receipt.ReceivedAt.After(existing) {
				receivedAt[key] = receipt.ReceivedAt
			}
		}
	}

	for _, order := range live {
		for _, line := range order.Lines {
			key := order.ID + "/" + line.ItemID
			ordered := line.StockQuantity()
			received := receivedByOrderItem[key]

			out.OrderedUnits += ordered
			if received > ordered {
				// Capped per line, before it reaches the total.
				received = ordered
			}
			out.ReceivedUnits += received

			switch {
			case line.DeliverBy.IsZero():
				out.Incomplete = append(out.Incomplete,
					"an order line has no delivery date, so it is counted in "+
						"neither on-time nor late")
			case receivedAt[key].IsZero():
				out.LateLines++
			case receivedAt[key].After(line.DeliverBy):
				out.LateLines++
			default:
				out.OnTimeLines++
			}
		}
	}

	if out.OrderedUnits > 0 {
		out.FillRate = float64(out.ReceivedUnits) / float64(out.OrderedUnits)
	}
	out.Incomplete = sortedCodes(out.Incomplete)
	return out
}

// RecallList is what a blocked lot reaches (SRS-MAT-013).
//
// Where the stock is, and who it was used on. A recall that only covered what
// is still on a shelf would miss exactly the patients it exists to find, which
// is the same rule SRS-CSSD-011 applies to a sterilizer load.
type RecallList struct {
	LotID   string
	LotCode string
	ItemID  string
	Reason  string

	// Holdings are where the remaining stock is, so somebody can go and get
	// it.
	Holdings []Balance
	// Consumptions are the movements that used it, carrying the patient and
	// encounter where there was one.
	Consumptions []Movement
	// Patients are the people it reached. Deduplicated, because one case can
	// use four of a lot and that is one patient to contact.
	Patients []string
}

// BuildRecall works out what a blocked lot reaches (SRS-MAT-013).
func BuildRecall(lot Lot, movements []Movement, balances []Balance) RecallList {
	out := RecallList{
		LotID: lot.ID, LotCode: lot.Code, ItemID: lot.ItemID,
		Reason: lot.BlockedReason,
	}

	for _, balance := range balances {
		if balance.LotID == lot.ID && balance.Quantity > 0 {
			out.Holdings = append(out.Holdings, balance)
		}
	}

	var patients []string
	for _, m := range movements {
		if m.LotID != lot.ID {
			continue
		}
		if m.Kind != MovementConsumption && m.Kind != MovementIssue {
			continue
		}
		out.Consumptions = append(out.Consumptions, m)
		if m.PatientID != "" {
			patients = append(patients, m.PatientID)
		}
	}
	out.Patients = sortedCodes(patients)

	sort.Slice(out.Consumptions, func(i, j int) bool {
		return out.Consumptions[i].OccurredAt.Before(out.Consumptions[j].OccurredAt)
	})
	return out
}
