package domain

import (
	"fmt"
	"math"
	"sort"
	"strings"
	"time"
)

// The intraoperative record (SRS-ANE-003), drug documentation (SRS-ANE-004),
// device ingestion (SRS-ANE-005), the airway (SRS-ANE-006) and fluid balance
// (SRS-ANE-007).

// EntrySource says where an intraoperative entry came from (SRS-ANE-005).
type EntrySource string

const (
	SourceManual EntrySource = "manual"
	SourceDevice EntrySource = "device"
	// SourceImported is a paper record typed up afterwards (SRS-ANE-011).
	// Distinct from manual, because a record made during the case and one
	// reconstructed from paper are different evidence.
	SourceImported EntrySource = "imported"
)

var knownSources = map[EntrySource]bool{
	SourceManual: true, SourceDevice: true, SourceImported: true,
}

// DeviceLink identifies the machine an entry came from (SRS-ANE-005).
type DeviceLink struct {
	DeviceID string
	Model    string
	// Connected is the connection state at the moment of the reading. The
	// requirement's clause is "integrated data are marked by device and
	// connection status", and a value recorded while the monitor was
	// disconnected is one nobody should trend.
	Connected bool
	// MeasuredAt is the device's own clock, kept apart from ours.
	MeasuredAt time.Time
}

// VitalEntry is one time-series value on the anaesthetic chart (SRS-ANE-003).
type VitalEntry struct {
	ID       string
	TenantID string
	RecordID string

	Code    string
	Display string
	Value   float64
	Unit    string

	Source EntrySource
	Device DeviceLink

	ObservedAt time.Time
	RecordedAt time.Time
	RecordedBy string
}

// DrugRoute is how a drug was given.
type DrugRoute string

// DrugEntry is one drug given during the case (SRS-ANE-004).
//
// A bolus and an infusion are the same shape: an infusion is a bolus with a
// rate and no end until it is stopped. Keeping them in one record means the
// total a patient received can be summed without joining two tables.
type DrugEntry struct {
	ID       string
	TenantID string
	RecordID string

	DrugCode    string
	DrugDisplay string
	Route       DrugRoute

	// Dose and DoseUnit are what was given. Amount, not volume: the whole of
	// SRS-ANE-004's unit validation is that a system which stored "5" without
	// knowing whether it was millilitres or milligrams has recorded nothing.
	Dose     float64
	DoseUnit string
	// Concentration converts a volume to a dose, for an infusion or a
	// dilution. Both halves or neither.
	ConcentrationAmount float64
	ConcentrationUnit   string
	ConcentrationVolume float64
	// RateMLPerHour is set for an infusion and zero for a bolus.
	RateMLPerHour float64
	// Infusion marks an entry that runs until stopped.
	Infusion  bool
	StoppedAt time.Time

	Source EntrySource
	Device DeviceLink

	GivenAt    time.Time
	RecordedAt time.Time
	RecordedBy string
	Note       string
}

// UnitFamily groups dose units that measure the same thing.
//
// The check SRS-ANE-004 asks for: "unsafe unit mismatch is blocked or requires
// explicit correction". A dose in millilitres against a drug prescribed in
// micrograms is the error that kills people, and it is caught by knowing which
// units belong together rather than by parsing strings.
type UnitFamily string

const (
	FamilyMass      UnitFamily = "mass"
	FamilyVolume    UnitFamily = "volume"
	FamilyUnits     UnitFamily = "units"
	FamilyMassPerKg UnitFamily = "mass_per_kg"
	FamilyUnknown   UnitFamily = "unknown"
)

var unitFamilies = map[string]UnitFamily{
	"mcg": FamilyMass, "ug": FamilyMass, "microgram": FamilyMass,
	"mg": FamilyMass, "g": FamilyMass, "ng": FamilyMass,
	"ml": FamilyVolume, "l": FamilyVolume,
	"unit": FamilyUnits, "units": FamilyUnits, "iu": FamilyUnits,
	"mcg/kg": FamilyMassPerKg, "mg/kg": FamilyMassPerKg,
}

// FamilyOf reports which family a unit belongs to.
func FamilyOf(unit string) UnitFamily {
	if family, ok := unitFamilies[strings.ToLower(strings.TrimSpace(unit))]; ok {
		return family
	}
	return FamilyUnknown
}

// NewDrugInput is one drug given.
type NewDrugInput struct {
	RecordID            string
	DrugCode            string
	DrugDisplay         string
	Route               DrugRoute
	Dose                float64
	DoseUnit            string
	ConcentrationAmount float64
	ConcentrationUnit   string
	ConcentrationVolume float64
	RateMLPerHour       float64
	Infusion            bool
	Source              EntrySource
	Device              DeviceLink
	GivenAt             time.Time
	Note                string
	// ExpectedUnit is what the drug is normally dosed in, from the formulary.
	// Empty means the formulary has nothing to say, and the mismatch check is
	// skipped rather than guessed at.
	ExpectedUnit string
	// AcknowledgedMismatch is the explicit correction SRS-ANE-004 allows: an
	// anaesthetist who means to record a volume against a drug the formulary
	// doses by mass says so, and the record keeps that they said so.
	AcknowledgedMismatch bool
}

// RecordDrug documents a drug given during a case (SRS-ANE-004).
func RecordDrug(id, tenantID string, in NewDrugInput, by string, now time.Time) (
	DrugEntry, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return DrugEntry{}, fmt.Errorf("%w: a drug entry belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(in.DrugCode) == "":
		return DrugEntry{}, fmt.Errorf("%w: a drug entry names its drug",
			ErrInvalidRecord)
	case math.IsNaN(in.Dose) || math.IsInf(in.Dose, 0) || in.Dose < 0:
		return DrugEntry{}, fmt.Errorf("%w: a dose is a non-negative number",
			ErrInvalidRecord)
	case strings.TrimSpace(in.DoseUnit) == "":
		// A system that stored "5" without knowing whether it was millilitres
		// or milligrams has recorded nothing.
		return DrugEntry{}, fmt.Errorf("%w: a dose has a unit", ErrInvalidRecord)
	}

	source := in.Source
	if source == "" {
		source = SourceManual
	}
	if !knownSources[source] {
		return DrugEntry{}, fmt.Errorf("%w: unknown source %q", ErrInvalidRecord, source)
	}
	if source == SourceDevice && strings.TrimSpace(in.Device.DeviceID) == "" {
		return DrugEntry{}, fmt.Errorf("%w: a device entry names its device",
			ErrInvalidRecord)
	}
	if source != SourceDevice && strings.TrimSpace(by) == "" {
		return DrugEntry{}, fmt.Errorf("%w: a drug entry names who gave it",
			ErrInvalidRecord)
	}

	// SRS-ANE-004's unit check. A mismatch between the unit given and the unit
	// the formulary doses in is blocked unless somebody says explicitly that
	// they meant it.
	if expected := strings.TrimSpace(in.ExpectedUnit); expected != "" {
		given, want := FamilyOf(in.DoseUnit), FamilyOf(expected)
		if want != FamilyUnknown && given != want && !in.AcknowledgedMismatch {
			return DrugEntry{}, fmt.Errorf(
				"%w: %s is dosed in %s and this entry is in %s; correct it or "+
					"record that the difference is intended",
				ErrInvalidRecord, in.DrugDisplay, expected, in.DoseUnit)
		}
	}

	if in.Infusion {
		switch {
		case in.RateMLPerHour < 0:
			return DrugEntry{}, fmt.Errorf("%w: an infusion rate is not negative",
				ErrInvalidRecord)
		case in.ConcentrationAmount <= 0 || in.ConcentrationVolume <= 0:
			// Without both halves the rate cannot be turned into a dose, and
			// the chart would show a number with no clinical meaning.
			return DrugEntry{}, fmt.Errorf(
				"%w: an infusion records what is in the syringe and in what volume",
				ErrInvalidRecord)
		}
	}

	given := in.GivenAt
	if given.IsZero() {
		given = now
	}

	return DrugEntry{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		DrugCode:    strings.TrimSpace(in.DrugCode),
		DrugDisplay: strings.TrimSpace(in.DrugDisplay), Route: in.Route,
		Dose: in.Dose, DoseUnit: strings.TrimSpace(in.DoseUnit),
		ConcentrationAmount: in.ConcentrationAmount,
		ConcentrationUnit:   strings.TrimSpace(in.ConcentrationUnit),
		ConcentrationVolume: in.ConcentrationVolume,
		RateMLPerHour:       in.RateMLPerHour, Infusion: in.Infusion,
		Source: source, Device: in.Device,
		GivenAt: given.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by), Note: strings.TrimSpace(in.Note),
	}, nil
}

// AirwayEvent is what was done to the airway (SRS-ANE-006).
type AirwayEvent struct {
	ID       string
	TenantID string
	RecordID string

	// Device is what was used — "Macintosh 3", "LMA 4", "size 8 ETT".
	Device string
	// Attempt counts from 1. Every attempt is recorded, because the number of
	// attempts is the single most useful thing in the record for the next
	// anaesthetist.
	Attempt int
	// Grade is the laryngoscopy view obtained.
	Grade AirwayGrade
	// Successful says whether this attempt secured the airway.
	Successful bool
	// Difficulty and Complications describe what happened.
	Difficulty    string
	Complications []string
	// Adjuncts are what was needed — bougie, videolaryngoscope, external
	// laryngeal manipulation.
	Adjuncts []string

	OccurredAt time.Time
	RecordedBy string
}

// NewAirwayInput is one airway attempt.
type NewAirwayInput struct {
	RecordID      string
	Device        string
	Attempt       int
	Grade         AirwayGrade
	Successful    bool
	Difficulty    string
	Complications []string
	Adjuncts      []string
	OccurredAt    time.Time
}

// RecordAirway documents an airway attempt (SRS-ANE-006).
func RecordAirway(id, tenantID string, in NewAirwayInput, by string,
	now time.Time) (AirwayEvent, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return AirwayEvent{}, fmt.Errorf("%w: an airway event belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Device) == "":
		return AirwayEvent{}, fmt.Errorf("%w: an airway event names the device used",
			ErrInvalidRecord)
	case in.Attempt < 1:
		// Attempts count from one. A zeroth attempt would make the count of
		// attempts, which is what the next anaesthetist reads, wrong.
		return AirwayEvent{}, fmt.Errorf("%w: airway attempts count from 1",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return AirwayEvent{}, fmt.Errorf("%w: an airway event names who performed it",
			ErrInvalidRecord)
	}

	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}
	return AirwayEvent{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		Device: strings.TrimSpace(in.Device), Attempt: in.Attempt,
		Grade: in.Grade, Successful: in.Successful,
		Difficulty:    strings.TrimSpace(in.Difficulty),
		Complications: trimmedAll(in.Complications),
		Adjuncts:      trimmedAll(in.Adjuncts),
		OccurredAt:    occurred.UTC(), RecordedBy: strings.TrimSpace(by),
	}, nil
}

// DifficultAirway summarises an airway management episode (SRS-ANE-006).
//
// Derived from the attempts rather than set as a flag, because "difficult" is
// a judgement somebody can forget to tick and a run of four attempts with a
// bougie is not something the record should need reminding about.
type DifficultAirway struct {
	Attempts int
	// Difficult is true where more than two attempts were needed, where an
	// adjunct was required, or where the anaesthetist described difficulty.
	// Three signals, because each of them alone misses cases: an easy view
	// with four attempts is a difficult airway, and so is a first-pass success
	// that needed a videolaryngoscope.
	Difficult bool
	Reasons   []string
	// FinalDevice is what secured the airway, which is what the next
	// anaesthetist starts from.
	FinalDevice   string
	Complications []string
}

// DefaultDifficultAttempts is the attempt count that marks an airway
// difficult. Two, which is the threshold most published definitions use.
const DefaultDifficultAttempts = 2

// SummariseAirway derives the difficult-airway picture (SRS-ANE-006).
func SummariseAirway(events []AirwayEvent) DifficultAirway {
	out := DifficultAirway{}
	seen := map[string]bool{}

	ordered := make([]AirwayEvent, len(events))
	copy(ordered, events)
	sort.SliceStable(ordered, func(i, j int) bool {
		return ordered[i].Attempt < ordered[j].Attempt
	})

	for _, event := range ordered {
		if event.Attempt > out.Attempts {
			out.Attempts = event.Attempt
		}
		if event.Successful {
			out.FinalDevice = event.Device
		}
		for _, complication := range event.Complications {
			if !seen["c:"+complication] {
				out.Complications = append(out.Complications, complication)
				seen["c:"+complication] = true
			}
		}
		if len(event.Adjuncts) > 0 && !seen["adjunct"] {
			out.Reasons = append(out.Reasons,
				"adjuncts required: "+strings.Join(event.Adjuncts, ", "))
			seen["adjunct"] = true
		}
		if event.Difficulty != "" && !seen["d:"+event.Difficulty] {
			out.Reasons = append(out.Reasons, event.Difficulty)
			seen["d:"+event.Difficulty] = true
		}
	}

	if out.Attempts > DefaultDifficultAttempts {
		out.Reasons = append(out.Reasons,
			fmt.Sprintf("%d attempts", out.Attempts))
	}
	out.Difficult = len(out.Reasons) > 0
	sort.Strings(out.Reasons)
	return out
}

// FluidDirection is whether fluid went in or out.
type FluidDirection string

const (
	FluidIn  FluidDirection = "in"
	FluidOut FluidDirection = "out"
)

// FluidEntry is one recorded volume (SRS-ANE-007).
type FluidEntry struct {
	ID       string
	TenantID string
	RecordID string

	Direction FluidDirection
	// Kind is crystalloid, colloid, blood, urine, blood loss, drain. The
	// deployment's own list, because a transfusion service and a theatre name
	// them differently.
	Kind     string
	Label    string
	VolumeML float64
	// ProductID links a transfused unit to the blood bank's record
	// (SRS-BLD). Empty for anything that is not a blood product.
	ProductID string

	OccurredAt time.Time
	RecordedAt time.Time
	RecordedBy string
}

// FluidBalance is a case's running totals (SRS-ANE-007).
type FluidBalance struct {
	InML  float64
	OutML float64
	NetML float64
	// BloodLossML and TransfusedML are called out separately because they are
	// the two numbers the surgeon and the transfusion service ask for, and
	// burying them in the totals loses both.
	BloodLossML  float64
	TransfusedML float64
	UrineML      float64
	Entries      int
}

// BloodLossKind and the rest name the categories the balance calls out.
const (
	KindBloodLoss   = "blood_loss"
	KindTransfusion = "transfusion"
	KindUrine       = "urine"
)

// Balance totals a case's fluids (SRS-ANE-007).
//
// Computed from the entries every time. "Totals reconcile to event records" is
// the requirement, and a stored running total is one that can disagree with
// the entries it came from.
func Balance(entries []FluidEntry) FluidBalance {
	out := FluidBalance{}
	for _, entry := range entries {
		out.Entries++
		switch entry.Direction {
		case FluidIn:
			out.InML += entry.VolumeML
		case FluidOut:
			out.OutML += entry.VolumeML
		}
		switch entry.Kind {
		case KindBloodLoss:
			out.BloodLossML += entry.VolumeML
		case KindTransfusion:
			out.TransfusedML += entry.VolumeML
		case KindUrine:
			out.UrineML += entry.VolumeML
		}
	}
	out.NetML = out.InML - out.OutML
	return out
}

// NewFluidInput is one recorded volume.
type NewFluidInput struct {
	RecordID   string
	Direction  FluidDirection
	Kind       string
	Label      string
	VolumeML   float64
	ProductID  string
	OccurredAt time.Time
}

// RecordFluid records a volume in or out (SRS-ANE-007).
func RecordFluid(id, tenantID string, in NewFluidInput, by string, now time.Time) (
	FluidEntry, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return FluidEntry{}, fmt.Errorf("%w: a fluid entry belongs to a record",
			ErrInvalidRecord)
	case in.Direction != FluidIn && in.Direction != FluidOut:
		return FluidEntry{}, fmt.Errorf("%w: a fluid entry goes in or out",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Kind) == "":
		// A litre in and a litre of blood out are different clinical
		// pictures, and the kind is what tells them apart.
		return FluidEntry{}, fmt.Errorf("%w: a fluid entry names what it was",
			ErrInvalidRecord)
	case math.IsNaN(in.VolumeML) || math.IsInf(in.VolumeML, 0) || in.VolumeML < 0:
		return FluidEntry{}, fmt.Errorf("%w: a volume is a non-negative number",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return FluidEntry{}, fmt.Errorf("%w: a fluid entry names who recorded it",
			ErrInvalidRecord)
	}
	if in.Kind == KindTransfusion && strings.TrimSpace(in.ProductID) == "" {
		// A transfusion with no unit identifier cannot be reconciled against
		// the blood bank's issue record, which is half of every transfusion
		// audit.
		return FluidEntry{}, fmt.Errorf(
			"%w: a transfusion names the unit that was given", ErrInvalidRecord)
	}

	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}
	return FluidEntry{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		Direction: in.Direction, Kind: strings.TrimSpace(in.Kind),
		Label: strings.TrimSpace(in.Label), VolumeML: in.VolumeML,
		ProductID:  strings.TrimSpace(in.ProductID),
		OccurredAt: occurred.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by),
	}, nil
}

// NewVitalInput is one time-series value.
type NewVitalInput struct {
	RecordID   string
	Code       string
	Display    string
	Value      float64
	Unit       string
	Source     EntrySource
	Device     DeviceLink
	ObservedAt time.Time
}

// RecordVital records one intraoperative value (SRS-ANE-003, SRS-ANE-005).
func RecordVital(id, tenantID string, in NewVitalInput, by string, now time.Time) (
	VitalEntry, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return VitalEntry{}, fmt.Errorf("%w: a value belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Code) == "":
		return VitalEntry{}, fmt.Errorf("%w: a value names what was measured",
			ErrInvalidRecord)
	case math.IsNaN(in.Value) || math.IsInf(in.Value, 0):
		return VitalEntry{}, fmt.Errorf("%w: %q is not a measurement",
			ErrInvalidRecord, "NaN or infinity")
	}

	source := in.Source
	if source == "" {
		source = SourceManual
	}
	if !knownSources[source] {
		return VitalEntry{}, fmt.Errorf("%w: unknown source %q", ErrInvalidRecord, source)
	}
	if source == SourceDevice && strings.TrimSpace(in.Device.DeviceID) == "" {
		// "Integrated data are marked by device": a device reading from no
		// device is a manual entry claiming otherwise.
		return VitalEntry{}, fmt.Errorf("%w: a device value names its device",
			ErrInvalidRecord)
	}
	if source != SourceDevice && strings.TrimSpace(by) == "" {
		return VitalEntry{}, fmt.Errorf("%w: a value names who recorded it",
			ErrInvalidRecord)
	}

	observed := in.ObservedAt
	if observed.IsZero() {
		observed = now
	}
	return VitalEntry{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		Code: strings.TrimSpace(in.Code), Display: strings.TrimSpace(in.Display),
		Value: in.Value, Unit: strings.TrimSpace(in.Unit),
		Source: source, Device: in.Device,
		ObservedAt: observed.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by),
	}, nil
}

// Trustworthy reports a value that may be trended.
//
// A device reading taken while the monitor was disconnected is not: the
// requirement asks for the connection status to be marked, and the reason to
// mark it is that somebody downstream has to be able to exclude it.
func (v VitalEntry) Trustworthy() bool {
	if v.Source != SourceDevice {
		return true
	}
	return v.Device.Connected
}
