package domain

import (
	"strings"
	"time"
)

// Lines, tubes, drains and catheters (SRS-NUR-006).
//
// The acceptance criterion — "device-days can be calculated from canonical
// dates" — is the whole requirement. Device-days are the denominator of the
// infection rates a hospital publishes and is judged on: CLABSI per 1,000
// central-line days, CAUTI per 1,000 catheter days. A denominator derived from
// how many times somebody documented line care is a denominator that falls
// when the ward is busy, which makes the rate rise exactly when it should not.
//
// So insertion and removal are canonical dates on the device record, and the
// count is computed from them and nothing else.

// DeviceKind is what was inserted.
type DeviceKind string

const (
	DeviceCentralLine      DeviceKind = "central_line"
	DevicePeripheralLine   DeviceKind = "peripheral_line"
	DeviceUrinaryCatheter  DeviceKind = "urinary_catheter"
	DeviceDrain            DeviceKind = "drain"
	DeviceFeedingTube      DeviceKind = "feeding_tube"
	DeviceEndotrachealTube DeviceKind = "endotracheal_tube"
	DeviceChestTube        DeviceKind = "chest_tube"
)

var knownDeviceKinds = map[DeviceKind]bool{
	DeviceCentralLine: true, DevicePeripheralLine: true,
	DeviceUrinaryCatheter: true, DeviceDrain: true,
	DeviceFeedingTube: true, DeviceEndotrachealTube: true,
	DeviceChestTube: true,
}

// SurveillanceDevice reports whether this kind counts towards a published
// infection rate.
//
// Named rather than left to the reporting query, because the set is a
// surveillance definition and a reporting query that quietly disagrees with it
// produces a rate nobody can reconcile.
func (k DeviceKind) SurveillanceDevice() bool {
	return k == DeviceCentralLine || k == DeviceUrinaryCatheter ||
		k == DeviceEndotrachealTube
}

// Device is one line, tube, drain or catheter (SRS-NUR-006).
type Device struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Kind        DeviceKind
	// Site is where it is, and Laterality which side. A central line "in the
	// jugular" with no side is a line nobody can find in a hurry.
	Site       string
	Laterality Laterality
	// Size and Lot identify the product, so a recall can find the patients.
	Size string
	Lot  string

	// InsertedAt and RemovedAt are the canonical dates. Nothing else may be
	// used to compute device-days.
	InsertedAt time.Time
	InsertedBy string
	RemovedAt  time.Time
	RemovedBy  string
	// RemovalReason separates a planned removal from a line pulled because it
	// was infected, which is the distinction surveillance turns on.
	RemovalReason string

	// Care is the record of what was done to it — dressing changes, flushes.
	// Recorded because it is nursing work and because a dressing overdue is
	// actionable, but never used as a proxy for the device being in place.
	Care []DeviceCare

	Version int64
}

// Laterality is which side.
type Laterality string

const (
	LateralityLeft          Laterality = "left"
	LateralityRight         Laterality = "right"
	LateralityBilateral     Laterality = "bilateral"
	LateralityNotApplicable Laterality = "not_applicable"
)

var knownLateralities = map[Laterality]bool{
	LateralityLeft: true, LateralityRight: true,
	LateralityBilateral: true, LateralityNotApplicable: true,
}

// DeviceCare is one episode of looking after a device.
type DeviceCare struct {
	ID string
	// Kind is what was done: dressing change, flush, site inspection.
	Kind        string
	Finding     string
	OutputML    float64
	PerformedAt time.Time
	PerformedBy string
}

// NewDeviceInput is what recording an insertion needs.
type NewDeviceInput struct {
	PatientID   string
	EncounterID string
	Kind        DeviceKind
	Site        string
	Laterality  Laterality
	Size        string
	Lot         string
	InsertedAt  time.Time
}

// NewDevice records an insertion.
func NewDevice(id, tenantID string, in NewDeviceInput, insertedBy string,
	now time.Time) (*Device, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a device needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a device needs an encounter")
	}
	if !knownDeviceKinds[in.Kind] {
		return nil, invalidf("unknown device kind %q", in.Kind)
	}
	if strings.TrimSpace(in.Site) == "" {
		return nil, invalidf("a device needs the site it was inserted at")
	}
	if strings.TrimSpace(insertedBy) == "" {
		return nil, invalidf("a device must record who inserted it")
	}
	laterality := in.Laterality
	if laterality == "" {
		laterality = LateralityNotApplicable
	}
	if !knownLateralities[laterality] {
		return nil, invalidf("unknown laterality %q", in.Laterality)
	}
	if in.InsertedAt.IsZero() {
		// Defaulting to now would put the device-day count out by however long
		// it took to chart, which is the one number this record exists for.
		return nil, invalidf("a device needs the time it was inserted")
	}
	inserted := in.InsertedAt.UTC()
	if inserted.After(now.UTC()) {
		return nil, invalidf("a device cannot have been inserted in the future")
	}

	return &Device{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Kind: in.Kind, Site: strings.TrimSpace(in.Site), Laterality: laterality,
		Size: strings.TrimSpace(in.Size), Lot: strings.TrimSpace(in.Lot),
		InsertedAt: inserted, InsertedBy: insertedBy, Version: 1,
	}, nil
}

// Remove records a removal.
func (d *Device) Remove(at time.Time, reason, by string, now time.Time) error {
	if !d.InPlace() {
		return notAllowedf("this device has already been removed")
	}
	if at.IsZero() {
		return invalidf("removing a device needs the time it was removed")
	}
	removed := at.UTC()
	if removed.Before(d.InsertedAt) {
		return invalidf("a device cannot be removed before it was inserted")
	}
	if removed.After(now.UTC()) {
		return invalidf("a device cannot have been removed in the future")
	}
	if strings.TrimSpace(reason) == "" {
		// Planned removal and removal for suspected infection are the same
		// event to the chart and different events to surveillance.
		return invalidf("removing a device needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("removing a device must record who removed it")
	}
	d.RemovedAt = removed
	d.RemovedBy = by
	d.RemovalReason = strings.TrimSpace(reason)
	d.Version++
	return nil
}

// InPlace reports whether the device is still in the patient.
func (d *Device) InPlace() bool { return d.RemovedAt.IsZero() }

// RecordCare adds a care episode.
func (d *Device) RecordCare(care DeviceCare, now time.Time) error {
	if !d.InPlace() {
		return notAllowedf("this device has been removed")
	}
	if strings.TrimSpace(care.Kind) == "" {
		return invalidf("device care needs to say what was done")
	}
	if strings.TrimSpace(care.PerformedBy) == "" {
		return invalidf("device care must record who performed it")
	}
	if care.PerformedAt.IsZero() {
		return invalidf("device care needs the time it was performed")
	}
	if care.PerformedAt.UTC().After(now.UTC()) {
		return invalidf("device care cannot have been performed in the future")
	}
	if care.PerformedAt.UTC().Before(d.InsertedAt) {
		return invalidf("device care cannot precede the insertion")
	}
	care.PerformedAt = care.PerformedAt.UTC()
	d.Care = append(d.Care, care)
	d.Version++
	return nil
}

// DeviceDays counts the surveillance denominator as of asOf (SRS-NUR-006).
//
// The convention is the one surveillance uses: a device is counted once for
// each calendar day on which it was in place, counting the day of insertion
// and the day of removal. A line inserted and removed the same afternoon is
// one device-day, not zero — it carried a day's risk.
//
// Calendar days in UTC. A ward's local midnight would be the more natural
// boundary, but a denominator that shifts with a daylight-saving change is a
// denominator that produces an unexplained blip in a published rate twice a
// year. The convention is stated here because the number is only comparable
// between hospitals if everybody counts it the same way.
func (d *Device) DeviceDays(asOf time.Time) int {
	if d.InsertedAt.IsZero() {
		return 0
	}
	start := d.InsertedAt.UTC().Truncate(24 * time.Hour)

	end := asOf.UTC()
	if !d.InPlace() && d.RemovedAt.Before(end) {
		end = d.RemovedAt.UTC()
	}
	if end.Before(d.InsertedAt.UTC()) {
		return 0
	}
	last := end.Truncate(24 * time.Hour)

	return int(last.Sub(start)/(24*time.Hour)) + 1
}

// Dwell is how long the device has been in, to the minute.
//
// Separate from DeviceDays because it answers a different question: dwell time
// drives "this cannula is due for replacement at 72 hours", and rounding that
// to calendar days would let a line sit for nearly two days past its limit.
func (d *Device) Dwell(asOf time.Time) time.Duration {
	if d.InsertedAt.IsZero() {
		return 0
	}
	end := asOf.UTC()
	if !d.InPlace() && d.RemovedAt.Before(end) {
		end = d.RemovedAt.UTC()
	}
	if end.Before(d.InsertedAt.UTC()) {
		return 0
	}
	return end.Sub(d.InsertedAt.UTC())
}
