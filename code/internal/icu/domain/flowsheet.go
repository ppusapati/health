package domain

import (
	"fmt"
	"math"
	"sort"
	"strings"
	"time"
)

// The high-frequency flowsheet (SRS-ICU-002), what a value's provenance is
// (SRS-ICU-003), and the fluid balance (SRS-ICU-007).

// SourceKind says where a value came from (SRS-ICU-003).
//
// The requirement's verification clause is the whole of it: "raw/device-derived
// values are distinguishable from manually validated chart values". A monitor
// produces a reading every few seconds and a great many are artefact — a
// saturation probe off a finger reads 60%, an arterial line being flushed
// reads a systolic of 300 — and a chart that absorbed them would carry each as
// fact.
type SourceKind string

const (
	SourceManual SourceKind = "manual"
	SourceDevice SourceKind = "device"
	// SourceCalculated is derived from other values in the chart. Kept apart
	// from manual because a derived number must not be re-derived from itself.
	SourceCalculated SourceKind = "calculated"
	SourceUnknown    SourceKind = "unknown"
)

// Validation is how far a value has got towards being chartable.
type Validation string

const (
	// ValidationNotRequired is a value a human entered. They validated it by
	// typing it.
	ValidationNotRequired Validation = "not_required"
	ValidationPending     Validation = "pending"
	ValidationConfirmed   Validation = "confirmed"
	ValidationRejected    Validation = "rejected"
)

// DefaultValidationFor is where a value starts, given where it came from.
func DefaultValidationFor(source SourceKind) Validation {
	if source == SourceDevice {
		return ValidationPending
	}
	return ValidationNotRequired
}

// Unit normalisation (SRS-ICU-002's "unit-normalized").
//
// A conversion table rather than a parser. Every entry is a unit a device or a
// nurse actually sends for the observation it belongs to, and an unknown pair
// is refused rather than guessed: a temperature silently read as Celsius when
// the monitor sent Fahrenheit is a fever that is not there.
type conversion struct {
	canonical string
	scale     float64
	offset    float64
}

var unitConversions = map[string]map[string]conversion{
	"temperature": {
		"cel":    {canonical: "Cel", scale: 1},
		"c":      {canonical: "Cel", scale: 1},
		"°c":     {canonical: "Cel", scale: 1},
		"degc":   {canonical: "Cel", scale: 1},
		"[degf]": {canonical: "Cel", scale: 5.0 / 9.0, offset: -32},
		"f":      {canonical: "Cel", scale: 5.0 / 9.0, offset: -32},
		"°f":     {canonical: "Cel", scale: 5.0 / 9.0, offset: -32},
	},
	"weight": {
		"kg": {canonical: "kg", scale: 1},
		"g":  {canonical: "kg", scale: 0.001},
		"lb": {canonical: "kg", scale: 0.45359237},
	},
	"volume": {
		"ml": {canonical: "mL", scale: 1},
		"l":  {canonical: "mL", scale: 1000},
		"cc": {canonical: "mL", scale: 1},
	},
	"pressure": {
		"mm[hg]": {canonical: "mm[Hg]", scale: 1},
		"mmhg":   {canonical: "mm[Hg]", scale: 1},
		"kpa":    {canonical: "mm[Hg]", scale: 7.50062},
	},
	"fraction": {
		"%":       {canonical: "%", scale: 1},
		"percent": {canonical: "%", scale: 1},
		// A fraction of one, which is how a ventilator sends FiO2.
		"1": {canonical: "%", scale: 100},
	},
}

// Dimension names the unit family an observation is measured in.
//
// Carried by the observation rather than inferred from its code, because the
// code system is the deployment's (LOINC, or a local one) and a hard-coded
// mapping from code to dimension would be a second terminology nobody
// maintains.
type Dimension string

// Normalise converts a value to its canonical unit.
//
// Returns false for a unit the dimension does not define. The caller stores
// the value as it arrived and marks it un-normalised rather than guessing: a
// number in the wrong unit that looks right is worse than one that is visibly
// unconverted.
func Normalise(dimension Dimension, value float64, unit string) (float64, string, bool) {
	table, ok := unitConversions[strings.ToLower(strings.TrimSpace(string(dimension)))]
	if !ok {
		return value, strings.TrimSpace(unit), false
	}
	conv, ok := table[strings.ToLower(strings.TrimSpace(unit))]
	if !ok {
		return value, strings.TrimSpace(unit), false
	}
	return (value + conv.offset) * conv.scale, conv.canonical, true
}

// DeviceSource identifies the machine a value came from (SRS-ICU-003).
type DeviceSource struct {
	// DeviceID is the hospital's asset identifier, so a run of bad readings
	// can be traced to the monitor that produced them rather than to the bed.
	DeviceID string
	Model    string
	// ChannelID is which parameter on the device — a monitor sends a dozen.
	ChannelID string
	// MeasuredAt is the device's own clock. Separate from the observation's
	// recorded time because the two disagree, and a monitor whose clock is an
	// hour out produces a trend that is an hour out.
	MeasuredAt time.Time
	// Quality is what the device said about its own reading, verbatim. Not
	// interpreted: every vendor's quality vocabulary is its own, and a mapping
	// that collapsed them would lose the one that mattered.
	Quality string
}

// Stale reports a feed that has stopped (SRS-ICU-012's "stale feeds are
// visibly marked").
//
// A zero measurement time is stale. A device source with no clock reading is
// one nothing is coming from, and treating it as fresh is how a dashboard
// shows a blood pressure from an hour ago as current.
func (d DeviceSource) Stale(now time.Time, after time.Duration) bool {
	if d.DeviceID == "" {
		return false
	}
	if d.MeasuredAt.IsZero() {
		return true
	}
	return now.Sub(d.MeasuredAt) > after
}

// DefaultStaleAfter is how long a feed may be silent before the dashboard says
// so. Two minutes: long enough to survive a cable moved during turning, short
// enough that a disconnected monitor is visible within one set of
// observations.
const DefaultStaleAfter = 2 * time.Minute

// Observation is one value on the flowsheet (SRS-ICU-002).
type Observation struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Code and CodeSystem are the deployment's terminology.
	CodeSystem string
	Code       string
	Display    string
	Dimension  Dimension

	// Value and Unit are as stored: normalised where the dimension knew how.
	Value float64
	Unit  string
	// RawValue and RawUnit are as they arrived. Kept because a conversion is a
	// transformation, and a chart that cannot show what the device actually
	// sent cannot be audited against it.
	RawValue float64
	RawUnit  string
	// Normalised is false where the unit was not one the dimension defines.
	Normalised bool

	Source     SourceKind
	Validation Validation
	Device     DeviceSource

	// ObservedAt is when the value was true of the patient; RecordedAt when it
	// reached the chart.
	ObservedAt time.Time
	RecordedAt time.Time
	RecordedBy string

	ValidatedBy    string
	ValidatedAt    time.Time
	ValidationNote string
}

// NewObservationInput is one flowsheet entry.
type NewObservationInput struct {
	EpisodeID  string
	CodeSystem string
	Code       string
	Display    string
	Dimension  Dimension
	Value      float64
	Unit       string
	Source     SourceKind
	Device     DeviceSource
	ObservedAt time.Time
}

// NewObservation records a flowsheet value (SRS-ICU-002, SRS-ICU-003).
func NewObservation(id, tenantID string, in NewObservationInput, recordedBy string,
	now time.Time) (Observation, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return Observation{}, fmt.Errorf("%w: an observation belongs to an episode",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.Code) == "":
		return Observation{}, fmt.Errorf("%w: an observation names what was measured",
			ErrInvalidEpisode)
	case math.IsNaN(in.Value) || math.IsInf(in.Value, 0):
		// A NaN in a flowsheet propagates into every total and every score
		// computed from it, and arrives at the bedside as a blank rather than
		// as an error.
		return Observation{}, fmt.Errorf("%w: %q is not a measurement",
			ErrInvalidEpisode, "NaN or infinity")
	}

	source := in.Source
	if source == "" {
		source = SourceManual
	}
	if source == SourceDevice && strings.TrimSpace(in.Device.DeviceID) == "" {
		// The whole point of the distinction is being able to say which
		// machine. A device reading from no device is a manual entry claiming
		// otherwise.
		return Observation{}, fmt.Errorf("%w: a device reading names its device",
			ErrInvalidEpisode)
	}
	if source != SourceDevice && strings.TrimSpace(recordedBy) == "" {
		return Observation{}, fmt.Errorf("%w: an observation names who recorded it",
			ErrInvalidEpisode)
	}

	observed := in.ObservedAt
	if observed.IsZero() {
		observed = now
	}

	value, unit, normalised := Normalise(in.Dimension, in.Value, in.Unit)

	return Observation{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		CodeSystem: strings.TrimSpace(in.CodeSystem),
		Code:       strings.TrimSpace(in.Code),
		Display:    strings.TrimSpace(in.Display),
		Dimension:  in.Dimension,
		Value:      value, Unit: unit,
		RawValue: in.Value, RawUnit: strings.TrimSpace(in.Unit),
		Normalised: normalised,
		Source:     source,
		Validation: DefaultValidationFor(source),
		Device:     in.Device,
		ObservedAt: observed.UTC(),
		RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(recordedBy),
	}, nil
}

// Confirm accepts a device reading into the chart (SRS-ICU-003).
func (o *Observation) Confirm(by, note string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: confirming a reading names who confirmed it",
			ErrInvalidEpisode)
	}
	if o.Validation == ValidationNotRequired {
		return fmt.Errorf("%w: this value was entered by a person and needs no confirmation",
			ErrInvalidEpisode)
	}
	o.Validation, o.ValidatedBy = ValidationConfirmed, strings.TrimSpace(by)
	o.ValidatedAt, o.ValidationNote = at.UTC(), strings.TrimSpace(note)
	return nil
}

// Reject discards an artefact (SRS-ICU-003).
//
// The reading stays in the record. A rejected value that vanished would leave
// a gap in the trend where an artefact was, and no way to see that somebody
// looked at it.
func (o *Observation) Reject(by, note string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: rejecting a reading names who rejected it",
			ErrInvalidEpisode)
	}
	if strings.TrimSpace(note) == "" {
		return fmt.Errorf("%w: rejecting a reading needs a reason", ErrInvalidEpisode)
	}
	o.Validation, o.ValidatedBy = ValidationRejected, strings.TrimSpace(by)
	o.ValidatedAt, o.ValidationNote = at.UTC(), strings.TrimSpace(note)
	return nil
}

// Chartable reports whether a value may be read as the patient's (SRS-ICU-009).
func (o Observation) Chartable() bool {
	return o.Validation == ValidationNotRequired || o.Validation == ValidationConfirmed
}

// ObservationList is a flowsheet slice.
type ObservationList []Observation

// Chartable returns only the values a score may be computed from.
//
// A function rather than a convention, because SRS-ICU-009 says a score is
// calculated "only from explicit validated inputs" and a convention is a thing
// somebody forgets on the one code path that matters.
func (l ObservationList) Chartable() ObservationList {
	out := make(ObservationList, 0, len(l))
	for _, o := range l {
		if o.Chartable() {
			out = append(out, o)
		}
	}
	return out
}

// Latest returns the most recent chartable value for a code.
func (l ObservationList) Latest(code string) (Observation, bool) {
	var best Observation
	found := false
	for _, o := range l {
		if o.Code != code || !o.Chartable() {
			continue
		}
		if !found || o.ObservedAt.After(best.ObservedAt) {
			best, found = o, true
		}
	}
	return best, found
}

// Fluid balance (SRS-ICU-007).

// BalanceDirection is whether fluid went in or out.
type BalanceDirection string

const (
	BalanceIntake BalanceDirection = "intake"
	BalanceOutput BalanceDirection = "output"
)

// BalanceEntry is one recorded volume.
//
// Corrections are versioned rather than overwritten: SRS-ICU-007's clause is
// "late corrections are versioned; totals recalculate", and a fluid balance
// that was silently edited is one a renal consultant cannot reason about the
// next morning.
type BalanceEntry struct {
	ID        string
	TenantID  string
	EpisodeID string

	Direction BalanceDirection
	// Route is oral, IV, nasogastric, urine, drain, stool. Free text against a
	// deployment's own list.
	Route string
	// VolumeML is normalised on the way in.
	VolumeML float64

	OccurredAt time.Time
	RecordedAt time.Time
	RecordedBy string

	// SupersededBy names the entry that corrected this one. A superseded entry
	// is excluded from totals and kept in the record.
	SupersededBy string
	// Corrects names the entry this one replaces.
	Corrects string
	// CorrectionReason is why. Required, because an unexplained correction to
	// a fluid balance is the one a review asks about.
	CorrectionReason string
}

// NewBalanceEntryInput is one volume in or out.
type NewBalanceEntryInput struct {
	EpisodeID  string
	Direction  BalanceDirection
	Route      string
	Volume     float64
	Unit       string
	OccurredAt time.Time
	// Corrects and CorrectionReason make this entry a correction of another.
	Corrects         string
	CorrectionReason string
}

// NewBalanceEntry records a volume (SRS-ICU-007).
func NewBalanceEntry(id, tenantID string, in NewBalanceEntryInput, recordedBy string,
	now time.Time) (BalanceEntry, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return BalanceEntry{}, fmt.Errorf("%w: a balance entry belongs to an episode",
			ErrInvalidEpisode)
	case in.Direction != BalanceIntake && in.Direction != BalanceOutput:
		return BalanceEntry{}, fmt.Errorf("%w: a balance entry goes in or out",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.Route) == "":
		// Two litres in is a different clinical picture from two litres of
		// blood out, and the route is what tells them apart.
		return BalanceEntry{}, fmt.Errorf("%w: a balance entry names its route",
			ErrInvalidEpisode)
	case strings.TrimSpace(recordedBy) == "":
		return BalanceEntry{}, fmt.Errorf("%w: a balance entry names who recorded it",
			ErrInvalidEpisode)
	case math.IsNaN(in.Volume) || math.IsInf(in.Volume, 0) || in.Volume < 0:
		return BalanceEntry{}, fmt.Errorf("%w: a volume is a non-negative number",
			ErrInvalidEpisode)
	}
	if strings.TrimSpace(in.Corrects) != "" && strings.TrimSpace(in.CorrectionReason) == "" {
		return BalanceEntry{}, fmt.Errorf(
			"%w: a correction to a fluid balance needs a reason", ErrInvalidEpisode)
	}

	volume, _, ok := Normalise("volume", in.Volume, in.Unit)
	if !ok {
		return BalanceEntry{}, fmt.Errorf("%w: %q is not a volume this system converts",
			ErrInvalidEpisode, in.Unit)
	}

	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}

	return BalanceEntry{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		Direction: in.Direction, Route: strings.TrimSpace(in.Route),
		VolumeML:   volume,
		OccurredAt: occurred.UTC(), RecordedAt: now.UTC(),
		RecordedBy:       strings.TrimSpace(recordedBy),
		Corrects:         strings.TrimSpace(in.Corrects),
		CorrectionReason: strings.TrimSpace(in.CorrectionReason),
	}, nil
}

// Balance is a period's totals.
type Balance struct {
	From     time.Time
	To       time.Time
	IntakeML float64
	OutputML float64
	// NetML is intake minus output. The number the ward round reads.
	NetML float64
	// Entries is how many live entries the totals came from, so a total of
	// zero from no entries is distinguishable from a genuine zero balance.
	Entries int
	// Corrections is how many of them replaced an earlier entry.
	Corrections int
}

// Totals recalculates a period's balance (SRS-ICU-007).
//
// Superseded entries are excluded and their replacements counted, which is
// what "totals recalculate" means: the arithmetic is done from the live
// entries every time rather than adjusted in place, so a correction cannot
// leave a running total that no set of entries adds up to.
func Totals(entries []BalanceEntry, from, to time.Time) Balance {
	out := Balance{From: from.UTC(), To: to.UTC()}
	for _, e := range entries {
		if e.SupersededBy != "" {
			continue
		}
		if e.OccurredAt.Before(from) || !e.OccurredAt.Before(to) {
			continue
		}
		out.Entries++
		if e.Corrects != "" {
			out.Corrections++
		}
		switch e.Direction {
		case BalanceIntake:
			out.IntakeML += e.VolumeML
		case BalanceOutput:
			out.OutputML += e.VolumeML
		}
	}
	out.NetML = out.IntakeML - out.OutputML
	return out
}

// Hourly splits a period into hourly balances, which is how a chart is read.
func Hourly(entries []BalanceEntry, from, to time.Time) []Balance {
	var out []Balance
	for start := from.UTC().Truncate(time.Hour); start.Before(to); start = start.Add(time.Hour) {
		out = append(out, Totals(entries, start, start.Add(time.Hour)))
	}
	return out
}

// Ordered sorts a flowsheet by when the values were true of the patient.
func (l ObservationList) Ordered() ObservationList {
	out := make(ObservationList, len(l))
	copy(out, l)
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].ObservedAt.Equal(out[j].ObservedAt) {
			return out[i].Code < out[j].Code
		}
		return out[i].ObservedAt.Before(out[j].ObservedAt)
	})
	return out
}
