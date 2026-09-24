package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Source is where a number came from (SRS-FAC-009).
//
// The acceptance for SRS-FAC-009 is four words — "metrics retain meter/source
// provenance" — and this type is most of the answer. A command centre showing
// yesterday's electricity consumption is showing a number somebody will make a
// decision on, and "read off the panel by a technician" and "polled from the
// AMI meter" deserve different confidence. A figure whose origin was not kept
// cannot be argued with or corrected.
type Source string

const (
	// SourceManual is a human reading a dial and typing a number.
	SourceManual Source = "manual"
	// SourceSCADA is the plant control system.
	SourceSCADA Source = "scada"
	// SourceBMS is the building management system.
	SourceBMS Source = "bms"
	// SourceAMI is an automated metering infrastructure meter reporting
	// itself.
	SourceAMI Source = "ami"
	// SourceVendor is a figure that arrived on somebody's invoice.
	SourceVendor Source = "vendor"
	// SourceCalculated is derived rather than measured — a sub-meter
	// inferred by subtracting two others. Its own source because a
	// calculated figure inherits every error in its inputs.
	SourceCalculated Source = "calculated"
)

var knownSource = map[Source]bool{
	SourceManual: true, SourceSCADA: true, SourceBMS: true,
	SourceAMI: true, SourceVendor: true, SourceCalculated: true,
}

// Measured reports whether a source is an instrument rather than a person or
// an inference.
func (s Source) Measured() bool {
	return s == SourceSCADA || s == SourceBMS || s == SourceAMI
}

// Utility is what a meter measures (SRS-FAC-009).
type Utility string

const (
	UtilityElectricity Utility = "electricity"
	UtilityWater       Utility = "water"
	UtilityDiesel      Utility = "diesel"
	UtilityOxygen      Utility = "oxygen"
	UtilityLPG         Utility = "lpg"
	UtilitySteam       Utility = "steam"
	// UtilityEffluent is what leaves rather than what arrives, and is
	// metered because the consent to discharge has a number in it.
	UtilityEffluent Utility = "effluent"
)

var knownUtility = map[Utility]bool{
	UtilityElectricity: true, UtilityWater: true, UtilityDiesel: true,
	UtilityOxygen: true, UtilityLPG: true, UtilitySteam: true,
	UtilityEffluent: true,
}

// Meter is one measuring point (SRS-FAC-009).
type Meter struct {
	ID       string
	TenantID string

	// Code is what is written on the meter cupboard.
	Code    string
	Name    string
	Utility Utility
	// Unit is the unit every reading on this meter is in: "kWh", "litre",
	// "m3", "bar". Readings are integers in this unit, because a
	// consumption figure that disagrees with the bill in the third decimal
	// place is a conversation nobody wins. A meter that reads in
	// fractions declares a finer unit instead — "Wh" rather than "kWh".
	Unit string

	FacilityID string
	LocationID string
	// AssetID is the plant this meter measures, where it measures one:
	// the generator's fuel meter, the chiller's power meter.
	AssetID string

	// Source is how this meter is normally read. A reading may declare a
	// different one — a polled meter read by hand during a gateway outage
	// — and the reading's own source is what counts.
	Source Source
	// SourceRef is the address the automation knows it by: a Modbus
	// register, a BMS point name, a meter serial.
	SourceRef string

	// Cumulative means the register counts up and never resets, which is
	// what most utility meters do. Consumption is then the difference
	// between two readings rather than the reading itself.
	Cumulative bool
	// RegisterMax is where a cumulative register wraps back to zero. Zero
	// means it does not wrap. A five-digit kWh meter is 99999, and the
	// night it rolls over an unaware system reports the hospital consumed
	// negative ninety-nine thousand units.
	RegisterMax int

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Validate rejects a meter nothing could be read from.
func (m Meter) Validate() error {
	switch {
	case strings.TrimSpace(m.Code) == "":
		return fmt.Errorf("%w: a meter needs a code", ErrInvalidFacilities)
	case !knownUtility[m.Utility]:
		return fmt.Errorf("%w: unknown utility %q",
			ErrInvalidFacilities, m.Utility)
	case strings.TrimSpace(m.Unit) == "":
		// A number with no unit is not a measurement.
		return fmt.Errorf("%w: a meter declares its unit",
			ErrInvalidFacilities)
	case !knownSource[m.Source]:
		return fmt.Errorf("%w: unknown source %q",
			ErrInvalidFacilities, m.Source)
	case m.Source != SourceManual && strings.TrimSpace(m.SourceRef) == "":
		return fmt.Errorf("%w: a %s meter names its source reference",
			ErrInvalidFacilities, m.Source)
	case m.RegisterMax < 0:
		return fmt.Errorf("%w: a register maximum cannot be negative",
			ErrInvalidFacilities)
	case m.RegisterMax > 0 && !m.Cumulative:
		// Only a counting register wraps. A maximum on an instantaneous
		// meter is a rule that would fire on a perfectly good reading.
		return fmt.Errorf("%w: only a cumulative meter wraps",
			ErrInvalidFacilities)
	}
	return nil
}

// Reading is one meter reading (SRS-FAC-009).
//
// Append-only. A consumption series that can be edited is one that agrees
// with whatever the last person needed it to say.
type Reading struct {
	ID       string
	TenantID string
	MeterID  string

	// Value is in the meter's declared unit, as an integer.
	Value  int
	ReadAt time.Time

	// Source and SourceRef are this reading's provenance, which may differ
	// from the meter's: the point of recording it per reading rather than
	// per meter is the night the gateway was down.
	Source    Source
	SourceRef string

	RecordedBy string
	// RolledOver declares that the register passed its maximum since the
	// previous reading, so a lower number is a real increase.
	RolledOver bool
	Note       string

	CreatedAt time.Time
}

// RecordReading records a meter reading (SRS-FAC-009).
func RecordReading(id, tenantID string, meter Meter, value int, at time.Time,
	source Source, sourceRef string, rolledOver bool, note, by string,
	now time.Time) (Reading, error) {

	if err := meter.Validate(); err != nil {
		return Reading{}, err
	}
	switch {
	case strings.TrimSpace(id) == "":
		return Reading{}, fmt.Errorf("%w: a reading needs an id",
			ErrInvalidFacilities)
	case !meter.Active:
		return Reading{}, fmt.Errorf("%w: meter %q is not in use",
			ErrInvalidFacilities, meter.Code)
	case value < 0:
		return Reading{}, fmt.Errorf("%w: a reading cannot be negative",
			ErrInvalidFacilities)
	case meter.RegisterMax > 0 && value > meter.RegisterMax:
		return Reading{}, fmt.Errorf(
			"%w: %d is past this register's maximum of %d",
			ErrInvalidFacilities, value, meter.RegisterMax)
	case at.IsZero():
		return Reading{}, fmt.Errorf("%w: a reading says when it was taken",
			ErrInvalidFacilities)
	case at.After(now.Add(time.Hour)):
		return Reading{}, fmt.Errorf("%w: that reading is in the future",
			ErrInvalidFacilities)
	case !knownSource[source]:
		return Reading{}, fmt.Errorf("%w: unknown source %q",
			ErrInvalidFacilities, source)
	case source != SourceManual && strings.TrimSpace(sourceRef) == "":
		return Reading{}, fmt.Errorf("%w: a %s reading names its source",
			ErrInvalidFacilities, source)
	case strings.TrimSpace(by) == "":
		return Reading{}, fmt.Errorf("%w: a reading names who recorded it",
			ErrInvalidFacilities)
	case rolledOver && meter.RegisterMax <= 0:
		// Claiming a rollover on a register that does not wrap is how a
		// mistyped reading gets accepted as a real one.
		return Reading{}, fmt.Errorf("%w: meter %q has no register maximum",
			ErrInvalidFacilities, meter.Code)
	}

	return Reading{
		ID: id, TenantID: tenantID, MeterID: meter.ID,
		Value: value, ReadAt: at.UTC(),
		Source: source, SourceRef: strings.TrimSpace(sourceRef),
		RecordedBy: strings.TrimSpace(by), RolledOver: rolledOver,
		Note: strings.TrimSpace(note), CreatedAt: now.UTC(),
	}, nil
}

// Consumption is what a meter recorded over a window (SRS-FAC-009).
//
// It carries the meter and the sources it was built from, because that is the
// acceptance: a KPI that reached the command centre without its provenance is
// a number nobody can check.
type Consumption struct {
	MeterID string
	Utility Utility
	Unit    string
	From    time.Time
	To      time.Time

	// Quantity is in the meter's unit. For a cumulative meter it is what
	// was used over the window; for an instantaneous one it is the last
	// reading in it, because a pressure has no total.
	Quantity int
	// Readings is how many readings the figure rests on. Two is the
	// minimum for a cumulative meter and is worth showing: a month's
	// consumption from two readings is an average, not a series.
	Readings int
	// Sources are the distinct provenances that contributed, in the order
	// they were first seen.
	Sources []Source
	// Estimated is set when any contributing reading was typed by a person
	// or derived rather than measured. A figure that is 90% instrument and
	// 10% clipboard is an estimate, and saying so is the honest thing.
	Estimated bool
	// Rollovers counts register wraps crossed, so a suspicious figure can
	// be traced to one.
	Rollovers int
}

// Consume derives consumption from a meter's readings (SRS-FAC-009).
//
// Readings outside the window are ignored except that, for a cumulative
// meter, the figure is the difference between the first and last reading
// inside it: a window with one reading yields no consumption rather than a
// consumption equal to the register, which is the mistake that makes a
// command centre report a hospital using four million units in an hour.
func Consume(meter Meter, readings []Reading, from, to time.Time) (Consumption,
	bool) {

	in := make([]Reading, 0, len(readings))
	for _, reading := range readings {
		if reading.MeterID != meter.ID {
			continue
		}
		if reading.ReadAt.Before(from) || reading.ReadAt.After(to) {
			continue
		}
		in = append(in, reading)
	}
	if len(in) == 0 {
		return Consumption{}, false
	}
	sort.SliceStable(in, func(i, j int) bool {
		return in[i].ReadAt.Before(in[j].ReadAt)
	})

	out := Consumption{
		MeterID: meter.ID, Utility: meter.Utility, Unit: meter.Unit,
		From: from.UTC(), To: to.UTC(), Readings: len(in),
	}
	seen := map[Source]bool{}
	for _, reading := range in {
		if !seen[reading.Source] {
			seen[reading.Source] = true
			out.Sources = append(out.Sources, reading.Source)
		}
		if !reading.Source.Measured() {
			out.Estimated = true
		}
	}

	if !meter.Cumulative {
		// An instantaneous meter has no consumption to derive: the
		// readings are the measurement, and summing them would add a
		// pressure to a pressure. The answer over a window is the last
		// thing the instrument said, which is what somebody looking at
		// a VIE gauge wants to know.
		out.Quantity = in[len(in)-1].Value
		return out, true
	}

	if len(in) < 2 {
		// One reading of a counting register says where the counter
		// stands, not what was used.
		return Consumption{}, false
	}
	previous := in[0]
	for _, reading := range in[1:] {
		step := reading.Value - previous.Value
		if reading.RolledOver && meter.RegisterMax > 0 {
			step = (meter.RegisterMax - previous.Value) + reading.Value
			out.Rollovers++
		}
		if step < 0 {
			// A counter that went backwards without declaring a
			// rollover. Contributing nothing is wrong and
			// contributing a negative is worse; the honest answer
			// is that the series is not trustworthy.
			return Consumption{}, false
		}
		out.Quantity += step
		previous = reading
	}
	return out, true
}

// Downtime is how long a system was unavailable (SRS-FAC-009).
type Downtime struct {
	System System
	// Minutes is summed from the work orders that recorded it, which is
	// why the figure carries the orders below: a downtime KPI with no way
	// back to the incidents behind it cannot be investigated.
	Minutes int
	// Incidents is how many orders contributed.
	Incidents int
	// WorkOrderIDs is the provenance. Bounded by the caller's window
	// rather than by a limit here, because a truncated provenance list is
	// worse than none: it looks complete.
	WorkOrderIDs []string
	// Unmeasured counts closed orders on down assets that recorded no
	// downtime at all, so a suspiciously low figure declares its own gap.
	Unmeasured int
}

// SummariseDowntime totals recorded downtime by system (SRS-FAC-009).
//
// Only closed and resolved orders count. An open order's downtime is still
// accruing, and including it would make yesterday's KPI change tomorrow.
func SummariseDowntime(orders []WorkOrder, from, to time.Time) []Downtime {
	bySystem := map[System]*Downtime{}
	for _, order := range orders {
		if order.State != WorkClosed && order.State != WorkResolved {
			continue
		}
		when := order.ResolvedAt
		if when.IsZero() {
			when = order.ClosedAt
		}
		if when.IsZero() || when.Before(from) || when.After(to) {
			continue
		}

		entry := bySystem[order.System]
		if entry == nil {
			entry = &Downtime{System: order.System}
			bySystem[order.System] = entry
		}
		if order.DowntimeMinutes <= 0 {
			entry.Unmeasured++
			continue
		}
		entry.Minutes += order.DowntimeMinutes
		entry.Incidents++
		entry.WorkOrderIDs = append(entry.WorkOrderIDs, order.ID)
	}

	out := make([]Downtime, 0, len(bySystem))
	for _, entry := range bySystem {
		out = append(out, *entry)
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Minutes != out[j].Minutes {
			return out[i].Minutes > out[j].Minutes
		}
		return out[i].System < out[j].System
	})
	return out
}
