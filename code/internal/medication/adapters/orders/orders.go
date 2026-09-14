// Package orders adapts the order context for the medication context.
//
// A prescription is the clinical detail of a medication order, so placing one
// places an order: the order framework owns the number a ward reads down a
// phone, the routing to the pharmacy, the duplicate check, the audit trail and
// the order lifecycle, and this context asks it for those rather than keeping a
// second copy that drifts.
//
// The call goes through the order context's application service rather than its
// tables, so its own authorization, policy and events all run. That means a
// clinician who may prescribe must also hold the permission to place an order —
// which is correct, and is the point: a prescription is an order, and a
// permission model in which it is not is one where somebody can route around
// CPOE governance by going through the medication screen.
package orders

import (
	"context"
	"errors"

	medicationports "github.com/ppusapati/health/code/internal/medication/ports"
	ordersapp "github.com/ppusapati/health/code/internal/orders/application"
	ordersdomain "github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Placer is the part of the order service this adapter needs.
//
// An interface rather than the concrete service, so the medication context's
// tests can exercise the seam and so the dependency is visible at the
// composition root rather than implied.
type Placer interface {
	Place(ctx context.Context, in ordersapp.PlaceInput) (ordersapp.PlaceResult, error)
	Cancel(ctx context.Context, orderID, reason string) (ordersapp.CancelResult, error)
}

// Adapter implements the medication context's Orders port.
type Adapter struct {
	orders Placer
}

// New constructs the adapter.
func New(orders Placer) Adapter { return Adapter{orders: orders} }

var _ medicationports.Orders = Adapter{}

// Place raises the medication order behind a prescription.
//
// The duplicate warning is acknowledged here rather than surfaced. Two things
// make that the right call: the medication context has already run a
// duplicate-*therapy* check that matches on what the drug does rather than on
// its code (SRS-MED-003), which is the stronger of the two, and a prescriber
// answering the same question twice under two different names would learn to
// click through both. The order's own duplicate rule still records what it
// found, so the governance report is unchanged.
func (a Adapter) Place(ctx context.Context, scope authctx.TenantScope,
	req medicationports.OrderRequest) (medicationports.OrderRef, error) {

	timing := ordersdomain.Timing{
		StartAt:    req.StartsAt,
		EndAt:      req.EndsAt,
		Frequency:  req.Interval,
		TimesOfDay: req.TimesOfDay,
		DaysOfWeek: req.DaysOfWeek,
		PRN:        req.PRN,
	}

	result, err := a.orders.Place(ctx, ordersapp.PlaceInput{
		Type:        ordersdomain.TypeMedication,
		PatientID:   req.PatientID,
		EncounterID: req.EncounterID,
		Code: ordersdomain.Coding{
			System: req.Medication.System, Code: req.Medication.Code,
			Display: req.Medication.Display, Version: req.Medication.Version,
		},
		Detail:     req.Detail,
		Indication: req.Indication,
		IndicationCode: ordersdomain.Coding{
			System: req.IndicationCode.System, Code: req.IndicationCode.Code,
			Display: req.IndicationCode.Display,
		},
		Priority:              ordersdomain.PriorityRoutine,
		Timing:                timing,
		EnteredByID:           req.EnteredByID,
		AcknowledgeDuplicates: duplicateAcknowledgement,
	})
	if err != nil {
		return medicationports.OrderRef{}, err
	}
	if result.Order == nil {
		// Cannot happen with the acknowledgement supplied, and if it ever does
		// the prescription must not be written against an order that is not
		// there.
		return medicationports.OrderRef{}, errors.New(
			"medication: the order context returned a warning rather than an order")
	}
	return medicationports.OrderRef{
		OrderID: result.Order.ID, Number: result.Order.Number,
	}, nil
}

// duplicateAcknowledgement is the reason recorded against the order's own
// duplicate rule.
//
// A fixed sentence rather than the clinician's words, because these are not
// their words: the prescriber answered the duplicate-therapy warning, and
// attributing that answer to a different check would misreport what they were
// shown.
const duplicateAcknowledgement = "checked by the medication duplicate-therapy screen"

// Cancel stops the supply request behind a discontinued therapy.
//
// Best-effort by design. An order the pharmacy has already started refuses, and
// the therapy stops regardless: the patient not getting the drug is the part
// that matters, and the supply request catches up through SRS-ORD-004's own
// corrective workflow rather than by this context forcing it.
func (a Adapter) Cancel(ctx context.Context, scope authctx.TenantScope,
	orderID, reason string) error {

	_, err := a.orders.Cancel(ctx, orderID, reason)
	return err
}
