// Package medication adapts the medication context for the eMAR.
//
// This is the adapter the nursing context's MedicationOrders port was written
// against in Sprint 4C and left unimplemented: the eMAR was built against an
// interface rather than against a table it would then have to unlearn, and this
// is the table arriving.
//
// A projection, not a copy. Nursing needs to know what to give, when, and
// whether a pharmacist has checked it. It does not need the indication, the
// safety findings or the prescriber's reasoning — and the narrower the
// projection, the less of the medication context's shape a drug round depends
// on.
package medication

import (
	"context"
	"time"

	medicationdomain "github.com/ppusapati/health/code/internal/medication/domain"
	nursingdomain "github.com/ppusapati/health/code/internal/nursing/domain"
	nursingports "github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Schedules is the part of the medication context this adapter needs.
type Schedules interface {
	DueFor(ctx context.Context, scope authctx.TenantScope, encounterID string,
		from, to time.Time) ([]medicationdomain.DueDose, error)
	Prescription(ctx context.Context, scope authctx.TenantScope,
		prescriptionOrOrderID string) (*medicationdomain.Prescription, bool, error)
}

// Clock reads the current time.
//
// Only ever used to choose which step of a taper to display. Everything the
// eMAR records is stamped by the eMAR's own clock, which is the one that has to
// be the same as the ward's.
type Clock interface{ Now() time.Time }

// Adapter implements the nursing context's MedicationOrders port
// (SRS-NUR-007, SRS-MED-007).
type Adapter struct {
	schedules Schedules
	clock     Clock
}

// New constructs the adapter.
func New(schedules Schedules, clock Clock) Adapter {
	return Adapter{schedules: schedules, clock: clock}
}

var _ nursingports.MedicationOrders = Adapter{}

// Due returns the doses scheduled in a window (SRS-NUR-007, SRS-MED-007).
//
// Eligibility is applied on the medication side rather than here: only active,
// in-window prescriptions produce doses, and where the tenant requires
// pharmacist verification an unverified one produces none. The nursing context
// checks again at administration time, which is not redundancy — a worklist is
// read minutes before the drug is given, and a prescription discontinued in
// between is exactly the dose that must not be administered.
func (a Adapter) Due(ctx context.Context, scope authctx.TenantScope,
	encounterID string, from, to time.Time) ([]nursingdomain.DueDose, error) {

	doses, err := a.schedules.DueFor(ctx, scope, encounterID, from, to)
	if err != nil {
		return nil, err
	}

	out := make([]nursingdomain.DueDose, 0, len(doses))
	for _, dose := range doses {
		prescription, ok, err := a.schedules.Prescription(ctx, scope, dose.PrescriptionID)
		if err != nil {
			return nil, err
		}
		if !ok {
			continue
		}
		out = append(out, nursingdomain.DueDose{
			Order:       project(prescription, dose.Segment),
			ScheduledAt: dose.ScheduledAt,
		})
	}
	return out, nil
}

// Get projects one prescription for the eMAR.
//
// Keyed on the order identifier, because that is what the eMAR holds: an
// administration is recorded against the order a ward was told about, and the
// prescription identifier is this context's own business.
func (a Adapter) Get(ctx context.Context, scope authctx.TenantScope, orderID string) (
	nursingdomain.MedicationOrder, error) {

	prescription, ok, err := a.schedules.Prescription(ctx, scope, orderID)
	if err != nil {
		return nursingdomain.MedicationOrder{}, err
	}
	if !ok {
		return nursingdomain.MedicationOrder{}, rpcerr.NotFound("NUR_ORDER_NOT_FOUND",
			"no such medication order")
	}

	segment := medicationdomain.DoseSegment{}
	if len(prescription.Segments) > 0 {
		// The current step of a taper, not the first: a nurse giving a dose today
		// needs today's amount, and showing the starting dose of a steroid taper
		// three weeks in is how the wrong dose gets given.
		segment = currentSegment(prescription, a.now())
	}
	return project(prescription, segment), nil
}

// currentSegment picks the step in force at a moment.
func currentSegment(p *medicationdomain.Prescription,
	at time.Time) medicationdomain.DoseSegment {

	at = at.UTC()
	current := p.Segments[0]
	for _, seg := range p.Segments {
		if seg.StartsAt.After(at) {
			break
		}
		current = seg
	}
	return current
}

func (a Adapter) now() time.Time {
	if a.clock == nil {
		return time.Now().UTC()
	}
	return a.clock.Now().UTC()
}

// project narrows a prescription to what the eMAR acts on.
func project(p *medicationdomain.Prescription,
	segment medicationdomain.DoseSegment) nursingdomain.MedicationOrder {

	medication := p.Product
	if medication.Empty() {
		medication = p.Ingredient
	}

	order := nursingdomain.MedicationOrder{
		// The order identifier, not the prescription's: the eMAR records
		// administrations against what the ward was told about.
		OrderID:     p.OrderID,
		PatientID:   p.PatientID,
		EncounterID: p.EncounterID,
		Medication: nursingdomain.Coding{
			System: medication.System, Version: medication.Version,
			Code: medication.Code, Display: medication.Display,
		},
		Dose: nursingdomain.Quantity{
			Value: segment.Dose.Value, Unit: segment.Dose.Unit,
		},
		Route:      p.Route,
		Frequency:  segment.Timing.Describe(),
		Status:     projectStatus(p.Status),
		Verified:   p.Verification.Done(),
		VerifiedBy: p.Verification.By, VerifiedAt: p.Verification.At,
		PRN:      p.PRNScheduled(),
		StartsAt: p.StartsAt,
	}
	if stop := p.EffectiveStop(); !stop.IsZero() {
		order.EndsAt = stop
	} else if p.Stop.Kind == medicationdomain.StopAtTime {
		order.EndsAt = p.Stop.At
	}
	return order
}

// projectStatus maps a therapy status onto what the eMAR understands.
//
// The two vocabularies are close and not identical, and the mapping is written
// out rather than cast, so a therapy status added later does not silently
// become an eMAR status nobody designed for. A status this does not know maps to
// cancelled — the direction that stops doses rather than the one that produces
// them.
func projectStatus(s medicationdomain.TherapyStatus) nursingdomain.OrderStatus {
	switch s {
	case medicationdomain.TherapyDraft:
		return nursingdomain.OrderDraft
	case medicationdomain.TherapyActive:
		return nursingdomain.OrderActive
	case medicationdomain.TherapyHeld:
		return nursingdomain.OrderHeld
	case medicationdomain.TherapyCompleted:
		return nursingdomain.OrderCompleted
	case medicationdomain.TherapyDiscontinued:
		return nursingdomain.OrderCancelled
	}
	return nursingdomain.OrderCancelled
}
