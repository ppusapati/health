package domain

import (
	"sort"
	"strings"
	"time"
)

// The flowsheet and the fluid balance (SRS-NUR-003, SRS-NUR-004).
//
// Two rules shape this file, and both are about time.
//
// The first is SRS-NUR-003's: a late entry must be identified as late and must
// carry the actual observation time. A ward records a set of observations at
// 06:00 and the nurse reaches a terminal at 08:40; if the system stamps 08:40
// the chart says the patient was stable two hours after they in fact were, and
// the deterioration that happened in between is invisible. So observation time
// is supplied, recording time is taken from the clock, and the two are
// different columns that are never reconciled into one.
//
// The second is SRS-NUR-004's: corrections use an amendment trail. A fluid
// balance is a running total, and a running total that can be edited is a total
// nobody can reconstruct. So an entry is superseded rather than changed, and
// the balance is computed from what is live.

// The window inside which a recording counts as contemporaneous.
//
// Not zero: a nurse charting at the bedside takes a minute or two to type, and
// flagging that as a late entry would make the flag meaningless by making it
// universal. Fifteen minutes is short enough that a genuine catch-up round —
// the case the requirement exists for — still shows.
const LateEntryThreshold = 15 * time.Minute

// FlowsheetEntry is one charted observation (SRS-NUR-003).
type FlowsheetEntry struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// Code is what was measured: a pulse, a respiratory rate, a pain score.
	Code Coding
	// Value carries its unit, for the reason Quantity exists.
	Value      Quantity
	TextValue  string
	CodedValue Coding

	// ObservedAt is when the observation was true of the patient. Supplied by
	// the nurse, never defaulted to the clock: defaulting is exactly the
	// failure SRS-NUR-003 names, and it fails silently.
	ObservedAt time.Time
	// RecordedAt is when it reached the record.
	RecordedAt time.Time
	// Source is where the number came from: a bedside monitor, a manual
	// reading, a device feed. A monitor artefact and a nurse's count are both
	// "a pulse of 140" and are not equally trustworthy.
	Source EntrySource
	// DeviceID names the monitor where there was one.
	DeviceID string

	RecordedBy string
	// LateEntryReason is why the observation was charted late. Required when
	// the entry is late, because "the nurse was busy" and "this was found on
	// paper during downtime" lead to different conclusions in a review.
	LateEntryReason string

	// SupersededByID points at the correction that replaced this entry.
	SupersededByID string
	Version        int64
}

// EntrySource is where a charted value came from.
type EntrySource string

const (
	// SourceManual was read and typed by a person.
	SourceManual EntrySource = "manual"
	// SourceDevice arrived from a monitor or pump.
	SourceDevice EntrySource = "device"
	// SourcePaper was transcribed from a downtime paper chart (SRS-NUR-018).
	SourcePaper EntrySource = "paper"
	// SourcePatient was reported by the patient — a pain score is the common
	// case, and it is not a measurement.
	SourcePatient EntrySource = "patient"
)

var knownEntrySources = map[EntrySource]bool{
	SourceManual: true, SourceDevice: true,
	SourcePaper: true, SourcePatient: true,
}

// NewFlowsheetEntryInput is what charting an observation needs.
type NewFlowsheetEntryInput struct {
	PatientID       string
	EncounterID     string
	Code            Coding
	Value           Quantity
	TextValue       string
	CodedValue      Coding
	ObservedAt      time.Time
	Source          EntrySource
	DeviceID        string
	LateEntryReason string
}

// NewFlowsheetEntry charts an observation.
//
// now is the recording time. Anything the caller supplies for it is ignored:
// the one thing a late entry must not be able to do is claim it was on time.
func NewFlowsheetEntry(id, tenantID string, in NewFlowsheetEntryInput,
	recordedBy string, now time.Time) (*FlowsheetEntry, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a flowsheet entry needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a flowsheet entry needs an encounter")
	}
	if err := in.Code.Validate(); err != nil {
		return nil, err
	}
	if strings.TrimSpace(recordedBy) == "" {
		return nil, invalidf("a flowsheet entry needs an author")
	}
	if !knownEntrySources[in.Source] {
		return nil, invalidf("a charted value must say where it came from")
	}
	if in.Source == SourceDevice && strings.TrimSpace(in.DeviceID) == "" {
		// A value attributed to "a monitor" with no monitor named cannot be
		// checked against the monitor when somebody disputes it.
		return nil, invalidf("a device reading must name the device")
	}

	// SRS-NUR-003: the actual observation time, and it is not optional.
	if in.ObservedAt.IsZero() {
		return nil, invalidf("a flowsheet entry needs the time the observation was taken")
	}
	observed := in.ObservedAt.UTC()
	recorded := now.UTC()
	if observed.After(recorded) {
		return nil, invalidf("an observation cannot have been taken in the future")
	}

	entry := &FlowsheetEntry{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Code: in.Code, Value: in.Value,
		TextValue: strings.TrimSpace(in.TextValue), CodedValue: in.CodedValue,
		ObservedAt: observed, RecordedAt: recorded,
		Source: in.Source, DeviceID: strings.TrimSpace(in.DeviceID),
		RecordedBy:      recordedBy,
		LateEntryReason: strings.TrimSpace(in.LateEntryReason),
		Version:         1,
	}

	if entry.IsLate() && entry.LateEntryReason == "" {
		return nil, invalidf("a late entry must say why it is late")
	}
	if !entry.hasValue() {
		return nil, invalidf("a flowsheet entry needs a value")
	}
	// A measured number without a unit is not a measurement.
	if entry.Value.Value != 0 && strings.TrimSpace(entry.Value.Unit) == "" {
		return nil, invalidf("a measured value needs its unit")
	}
	return entry, nil
}

func (e *FlowsheetEntry) hasValue() bool {
	return e.Value.Value != 0 || e.TextValue != "" || !e.CodedValue.Empty()
}

// IsLate reports whether the observation reached the record outside the
// contemporaneous window (SRS-NUR-003).
func (e *FlowsheetEntry) IsLate() bool {
	return e.RecordedAt.Sub(e.ObservedAt) > LateEntryThreshold
}

// Delay is how far behind the observation the record was.
func (e *FlowsheetEntry) Delay() time.Duration {
	return e.RecordedAt.Sub(e.ObservedAt)
}

// Live reports whether this entry still counts.
func (e *FlowsheetEntry) Live() bool { return e.SupersededByID == "" }

// SortFlowsheet orders entries by when the observation was true, oldest first.
//
// By ObservedAt rather than RecordedAt: the chart is a picture of the patient,
// and sorting it by typing order puts a late 06:00 reading after the 08:00 one
// and produces a graph that says the patient improved and then deteriorated
// when in fact the reverse happened.
func SortFlowsheet(entries []*FlowsheetEntry) {
	sort.SliceStable(entries, func(i, j int) bool {
		if entries[i].ObservedAt.Equal(entries[j].ObservedAt) {
			return entries[i].RecordedAt.Before(entries[j].RecordedAt)
		}
		return entries[i].ObservedAt.Before(entries[j].ObservedAt)
	})
}

// FluidDirection is whether fluid went in or out.
type FluidDirection string

const (
	FluidIntake FluidDirection = "intake"
	FluidOutput FluidDirection = "output"
)

// FluidEntry is one recorded volume (SRS-NUR-004).
type FluidEntry struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Direction   FluidDirection
	// Category is what kind: oral, intravenous, urine, drain, vomit. Kept as a
	// coded value because the balance is reported by category — "2,400 ml out"
	// means something different when it is all drain loss.
	Category string
	// Volume is always in millilitres. One unit, converted on the way in,
	// because a running total summed across units is a number nobody can
	// defend.
	VolumeML float64

	ObservedAt time.Time
	RecordedAt time.Time
	RecordedBy string

	// SupersededByID and AmendmentReason are SRS-NUR-004's amendment trail. A
	// correction is a new entry that supersedes this one; this one stays,
	// because the shift total that was reported at the time was computed from
	// it.
	SupersededByID  string
	SupersedesID    string
	AmendmentReason string

	// VoidedReason retires an entry with no replacement — a volume charted
	// against the wrong patient.
	VoidedReason string
	Version      int64
}

// NewFluidEntryInput is what recording a volume needs.
type NewFluidEntryInput struct {
	PatientID   string
	EncounterID string
	Direction   FluidDirection
	Category    string
	VolumeML    float64
	ObservedAt  time.Time
}

// NewFluidEntry records intake or output.
func NewFluidEntry(id, tenantID string, in NewFluidEntryInput,
	recordedBy string, now time.Time) (*FluidEntry, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a fluid entry needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a fluid entry needs an encounter")
	}
	if in.Direction != FluidIntake && in.Direction != FluidOutput {
		return nil, invalidf("a fluid entry must say whether it went in or out")
	}
	if strings.TrimSpace(in.Category) == "" {
		return nil, invalidf("a fluid entry needs a category")
	}
	if strings.TrimSpace(recordedBy) == "" {
		return nil, invalidf("a fluid entry needs an author")
	}
	// Negative volumes are how a balance gets corrected by a system that has
	// no amendment trail. This one has an amendment trail.
	if in.VolumeML < 0 {
		return nil, invalidf("a volume cannot be negative; correct the entry instead")
	}
	if in.ObservedAt.IsZero() {
		return nil, invalidf("a fluid entry needs the time it was measured")
	}
	observed := in.ObservedAt.UTC()
	if observed.After(now.UTC()) {
		return nil, invalidf("a volume cannot have been measured in the future")
	}

	return &FluidEntry{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Direction: in.Direction, Category: strings.TrimSpace(in.Category),
		VolumeML: in.VolumeML, ObservedAt: observed, RecordedAt: now.UTC(),
		RecordedBy: recordedBy, Version: 1,
	}, nil
}

// MinAmendmentReasonLength keeps "fix" out of the amendment trail.
const MinAmendmentReasonLength = 5

// Correct produces the replacement for a mis-recorded volume (SRS-NUR-004).
//
// The original is not edited. It is marked superseded and stays readable,
// because the shift balance that was handed over was computed from it, and a
// trail that shows only the corrected figure cannot explain a decision made on
// the original.
func (f *FluidEntry) Correct(id string, volumeML float64, reason, by string,
	now time.Time) (*FluidEntry, error) {

	if !f.Live() {
		return nil, notAllowedf("this entry has already been corrected; correct the correction")
	}
	if len(strings.TrimSpace(reason)) < MinAmendmentReasonLength {
		return nil, invalidf("correcting a recorded volume needs a reason of at least %d characters",
			MinAmendmentReasonLength)
	}
	if volumeML < 0 {
		return nil, invalidf("a volume cannot be negative")
	}
	if strings.TrimSpace(by) == "" {
		return nil, invalidf("a correction needs an author")
	}

	return &FluidEntry{
		ID: id, TenantID: f.TenantID,
		PatientID: f.PatientID, EncounterID: f.EncounterID,
		Direction: f.Direction, Category: f.Category,
		VolumeML: volumeML, ObservedAt: f.ObservedAt, RecordedAt: now.UTC(),
		RecordedBy: by, SupersedesID: f.ID,
		AmendmentReason: strings.TrimSpace(reason), Version: 1,
	}, nil
}

// Void retires an entry that should never have been recorded at all.
func (f *FluidEntry) Void(reason, by string, now time.Time) error {
	if !f.Live() {
		return notAllowedf("this entry has already been corrected")
	}
	if len(strings.TrimSpace(reason)) < MinAmendmentReasonLength {
		return invalidf("voiding a recorded volume needs a reason of at least %d characters",
			MinAmendmentReasonLength)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("voiding needs an author")
	}
	f.VoidedReason = strings.TrimSpace(reason)
	f.RecordedAt = now.UTC()
	f.Version++
	return nil
}

// Live reports whether this entry counts towards the balance.
func (f *FluidEntry) Live() bool {
	return f.SupersededByID == "" && f.VoidedReason == ""
}

// FluidBalance is a running total over a period (SRS-NUR-004).
type FluidBalance struct {
	From, To time.Time
	IntakeML float64
	OutputML float64
	// ByCategory carries the breakdown, because "2,400 ml out" is a different
	// clinical picture depending on whether it is urine or blood.
	ByCategory map[string]float64
	// Entries counted, so a figure can be traced back to what produced it.
	Counted int
}

// NetML is intake less output. Positive means the patient is in positive
// balance — retaining fluid.
func (b FluidBalance) NetML() float64 { return b.IntakeML - b.OutputML }

// Balance totals the live entries whose observation time falls in [from, to).
//
// Superseded and voided entries are excluded, which is the whole point of the
// amendment trail: the history stays readable and the total stays right.
//
// Bounded by ObservedAt rather than RecordedAt, so a 06:00 reading charted at
// 08:40 falls in the night shift's balance where it belongs, not the morning's.
func Balance(entries []*FluidEntry, from, to time.Time) FluidBalance {
	out := FluidBalance{
		From: from.UTC(), To: to.UTC(),
		ByCategory: map[string]float64{},
	}
	for _, e := range entries {
		if !e.Live() {
			continue
		}
		if e.ObservedAt.Before(out.From) || !e.ObservedAt.Before(out.To) {
			continue
		}
		out.Counted++
		switch e.Direction {
		case FluidIntake:
			out.IntakeML += e.VolumeML
			out.ByCategory["intake:"+e.Category] += e.VolumeML
		case FluidOutput:
			out.OutputML += e.VolumeML
			out.ByCategory["output:"+e.Category] += e.VolumeML
		}
	}
	return out
}
