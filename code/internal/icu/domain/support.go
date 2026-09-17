package domain

import (
	"fmt"
	"math"
	"sort"
	"strings"
	"time"
)

// Organ support: ventilation (SRS-ICU-004), infusions (SRS-ICU-005), invasive
// devices (SRS-ICU-006) and the support record itself (SRS-ICU-011).

// SupportKind is a form of organ support (SRS-ICU-011).
type SupportKind string

const (
	SupportVentilation SupportKind = "ventilation"
	SupportVasopressor SupportKind = "vasopressor"
	// SupportRRT covers intermittent and continuous renal replacement.
	SupportRRT   SupportKind = "renal_replacement"
	SupportECMO  SupportKind = "ecmo"
	SupportOther SupportKind = "other"
)

var knownSupportKinds = map[SupportKind]bool{
	SupportVentilation: true, SupportVasopressor: true, SupportRRT: true,
	SupportECMO: true, SupportOther: true,
}

// Support is one run of organ support (SRS-ICU-011).
//
// Start and stop rather than a flag, because the question the unit is asked is
// "how many ventilator days", and a boolean answers "is this patient
// ventilated now" — which nobody was asking.
type Support struct {
	ID        string
	TenantID  string
	EpisodeID string

	Kind SupportKind
	// Label names a local modality where Kind is Other.
	Label string
	// Modality is the specific form — CVVHDF, VV-ECMO, noradrenaline. Free
	// text against the unit's own vocabulary.
	Modality string

	StartedAt time.Time
	StartedBy string
	StoppedAt time.Time
	StoppedBy string
	StopNote  string
}

// NewSupportInput starts organ support.
type NewSupportInput struct {
	EpisodeID string
	Kind      SupportKind
	Label     string
	Modality  string
	StartedAt time.Time
}

// StartSupport records the beginning of organ support (SRS-ICU-011).
func StartSupport(id, tenantID string, in NewSupportInput, by string, now time.Time) (
	Support, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return Support{}, fmt.Errorf("%w: organ support belongs to an episode",
			ErrInvalidEpisode)
	case !knownSupportKinds[in.Kind]:
		return Support{}, fmt.Errorf("%w: unknown support %q", ErrInvalidEpisode, in.Kind)
	case in.Kind == SupportOther && strings.TrimSpace(in.Label) == "":
		return Support{}, fmt.Errorf("%w: name the support this unit calls other",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return Support{}, fmt.Errorf("%w: starting organ support names who started it",
			ErrInvalidEpisode)
	}

	started := in.StartedAt
	if started.IsZero() {
		started = now
	}
	return Support{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		Kind: in.Kind, Label: strings.TrimSpace(in.Label),
		Modality:  strings.TrimSpace(in.Modality),
		StartedAt: started.UTC(), StartedBy: strings.TrimSpace(by),
	}, nil
}

// Stop ends a run of organ support.
func (s *Support) Stop(by, note string, at time.Time) error {
	if !s.StoppedAt.IsZero() {
		return fmt.Errorf("%w: this support was already stopped", ErrInvalidEpisode)
	}
	if at.Before(s.StartedAt) {
		return fmt.Errorf("%w: support stopped before it started", ErrInvalidEpisode)
	}
	s.StoppedAt, s.StoppedBy, s.StopNote = at.UTC(), strings.TrimSpace(by),
		strings.TrimSpace(note)
	return nil
}

// Active reports whether the support is still running.
func (s Support) Active() bool { return s.StoppedAt.IsZero() }

// Duration is how long the support ran, and whether it has finished.
func (s Support) Duration(now time.Time) (time.Duration, bool) {
	if s.StoppedAt.IsZero() {
		return now.Sub(s.StartedAt), false
	}
	return s.StoppedAt.Sub(s.StartedAt), true
}

// SupportDays counts days of a kind of support (SRS-ICU-017).
//
// Calendar days touched rather than elapsed hours divided by 24, because that
// is what a ventilator-day denominator means in every published definition:
// a patient ventilated from 23:00 to 01:00 was ventilated on two days.
func SupportDays(runs []Support, kind SupportKind, now time.Time) int {
	days := map[string]struct{}{}
	for _, run := range runs {
		if run.Kind != kind {
			continue
		}
		end := run.StoppedAt
		if end.IsZero() {
			end = now
		}
		for day := run.StartedAt.UTC().Truncate(24 * time.Hour); !day.After(end); day = day.Add(24 * time.Hour) {
			days[day.Format(time.DateOnly)] = struct{}{}
		}
	}
	return len(days)
}

// Ventilation (SRS-ICU-004).

// VentSetting is one ventilator configuration, as set or as measured.
//
// A timeline of settings rather than a current-state row: "ventilator timeline
// is queryable" is the requirement, and the question actually asked at review
// is what the settings were when the gas was taken.
type VentSetting struct {
	ID        string
	TenantID  string
	EpisodeID string
	SupportID string

	// Mode is the ventilator mode — SIMV, PSV, PRVC. The vendor's own string,
	// because every manufacturer names modes differently and a normalised
	// enumeration would lose the mode the machine is actually in.
	Mode string

	// Set parameters, and the measured ones beside them. Both, because the
	// difference between a set tidal volume and a delivered one is the
	// clinical finding.
	Parameters map[string]float64
	Measured   map[string]float64
	Units      map[string]string

	// DeviceID links the record to the ventilator where the unit is
	// integrated, and is empty where a nurse typed it.
	DeviceID string

	EffectiveAt time.Time
	RecordedAt  time.Time
	RecordedBy  string
	// ChangeReason explains a change. Optional: most changes are routine, and
	// demanding a reason for each would produce a column of "weaning".
	ChangeReason string
}

// NewVentSettingInput is one ventilator record.
type NewVentSettingInput struct {
	EpisodeID    string
	SupportID    string
	Mode         string
	Parameters   map[string]float64
	Measured     map[string]float64
	Units        map[string]string
	DeviceID     string
	EffectiveAt  time.Time
	ChangeReason string
}

// RecordVentSetting records ventilator settings (SRS-ICU-004).
func RecordVentSetting(id, tenantID string, in NewVentSettingInput, by string,
	now time.Time) (VentSetting, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return VentSetting{}, fmt.Errorf("%w: a ventilator record belongs to an episode",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.Mode) == "":
		return VentSetting{}, fmt.Errorf("%w: a ventilator record names its mode",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "" && strings.TrimSpace(in.DeviceID) == "":
		return VentSetting{}, fmt.Errorf(
			"%w: a ventilator record names who recorded it or which device sent it",
			ErrInvalidEpisode)
	}
	for name, value := range in.Parameters {
		if math.IsNaN(value) || math.IsInf(value, 0) {
			return VentSetting{}, fmt.Errorf("%w: %q is not a measurement",
				ErrInvalidEpisode, name)
		}
	}

	effective := in.EffectiveAt
	if effective.IsZero() {
		effective = now
	}
	return VentSetting{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		SupportID: strings.TrimSpace(in.SupportID), Mode: strings.TrimSpace(in.Mode),
		Parameters: copyFloats(in.Parameters), Measured: copyFloats(in.Measured),
		Units:       copyStrings(in.Units),
		DeviceID:    strings.TrimSpace(in.DeviceID),
		EffectiveAt: effective.UTC(), RecordedAt: now.UTC(),
		RecordedBy:   strings.TrimSpace(by),
		ChangeReason: strings.TrimSpace(in.ChangeReason),
	}, nil
}

func copyFloats(in map[string]float64) map[string]float64 {
	if in == nil {
		return map[string]float64{}
	}
	out := make(map[string]float64, len(in))
	for k, v := range in {
		out[k] = v
	}
	return out
}

func copyStrings(in map[string]string) map[string]string {
	if in == nil {
		return map[string]string{}
	}
	out := make(map[string]string, len(in))
	for k, v := range in {
		out[k] = v
	}
	return out
}

// VentTimeline is a settings history.
type VentTimeline []VentSetting

// Ordered sorts by when the settings took effect.
func (t VentTimeline) Ordered() VentTimeline {
	out := make(VentTimeline, len(t))
	copy(out, t)
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].EffectiveAt.Before(out[j].EffectiveAt)
	})
	return out
}

// At returns the settings in force at an instant.
//
// The question a blood gas is read against: what was the ventilator doing when
// this sample was taken.
func (t VentTimeline) At(instant time.Time) (VentSetting, bool) {
	var best VentSetting
	found := false
	for _, s := range t {
		if s.EffectiveAt.After(instant) {
			continue
		}
		if !found || s.EffectiveAt.After(best.EffectiveAt) {
			best, found = s, true
		}
	}
	return best, found
}

// Continuous infusions (SRS-ICU-005).

// Infusion is a drug running continuously, with its titration history.
type Infusion struct {
	ID        string
	TenantID  string
	EpisodeID string

	// PrescriptionID links to the Wave-1 drug chart. The prescription is the
	// authority; this is the record of what was actually running.
	PrescriptionID string
	DrugCode       string
	DrugDisplay    string

	// Concentration is what is in the bag: amount per volume. Recorded because
	// a rate in mL/h means nothing without it, and the commonest infusion
	// error is a bag made up to a different concentration from the one the
	// pump was programmed for.
	ConcentrationAmount float64
	ConcentrationUnit   string
	ConcentrationVolume float64

	// DoseUnit is what the unit titrates in — mcg/kg/min, units/h.
	DoseUnit string
	// WeightKg is the weight a weight-based dose was calculated from, frozen
	// at the time. A dose recomputed from a weight recorded three days later
	// is not the dose that was given.
	WeightKg float64

	StartedAt time.Time
	StartedBy string
	StoppedAt time.Time
	StoppedBy string

	// Titrations is the dose timeline. Append-only.
	Titrations []Titration
}

// Titration is one rate change (SRS-ICU-005).
type Titration struct {
	ID string
	// Rate is the pump rate and RateUnit its unit, usually mL/h.
	Rate     float64
	RateUnit string
	// Dose is the clinical dose the rate works out to, in the infusion's
	// DoseUnit. Stored rather than recomputed, because the concentration and
	// the weight it was derived from may both change later.
	Dose float64

	EffectiveAt time.Time
	RecordedAt  time.Time
	// RecordedBy is the nurse, or empty where DeviceID names the pump that
	// reported the change. One of the two is required: SRS-ICU-005's clause is
	// "responsible user/device source retained", and a rate change attributed
	// to nobody is one no review can ask about.
	RecordedBy string
	DeviceID   string
	Reason     string
}

// NewInfusionInput starts an infusion.
type NewInfusionInput struct {
	EpisodeID           string
	PrescriptionID      string
	DrugCode            string
	DrugDisplay         string
	ConcentrationAmount float64
	ConcentrationUnit   string
	ConcentrationVolume float64
	DoseUnit            string
	WeightKg            float64
	StartedAt           time.Time
}

// StartInfusion begins a continuous infusion (SRS-ICU-005).
func StartInfusion(id, tenantID string, in NewInfusionInput, by string, now time.Time) (
	Infusion, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return Infusion{}, fmt.Errorf("%w: an infusion belongs to an episode",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.DrugCode) == "":
		return Infusion{}, fmt.Errorf("%w: an infusion names its drug", ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return Infusion{}, fmt.Errorf("%w: starting an infusion names who started it",
			ErrInvalidEpisode)
	case in.ConcentrationAmount <= 0 || in.ConcentrationVolume <= 0:
		// Without both halves the rate on the pump cannot be turned into a
		// dose, and the chart would show a number with no clinical meaning.
		return Infusion{}, fmt.Errorf(
			"%w: an infusion records what is in the bag and in what volume",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.DoseUnit) == "":
		return Infusion{}, fmt.Errorf("%w: an infusion names the unit it is titrated in",
			ErrInvalidEpisode)
	}

	started := in.StartedAt
	if started.IsZero() {
		started = now
	}
	return Infusion{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		PrescriptionID:      strings.TrimSpace(in.PrescriptionID),
		DrugCode:            strings.TrimSpace(in.DrugCode),
		DrugDisplay:         strings.TrimSpace(in.DrugDisplay),
		ConcentrationAmount: in.ConcentrationAmount,
		ConcentrationUnit:   strings.TrimSpace(in.ConcentrationUnit),
		ConcentrationVolume: in.ConcentrationVolume,
		DoseUnit:            strings.TrimSpace(in.DoseUnit),
		WeightKg:            in.WeightKg,
		StartedAt:           started.UTC(), StartedBy: strings.TrimSpace(by),
	}, nil
}

// NewTitrationInput is one rate change.
type NewTitrationInput struct {
	Rate        float64
	RateUnit    string
	Dose        float64
	EffectiveAt time.Time
	DeviceID    string
	Reason      string
}

// Titrate records a rate change (SRS-ICU-005).
func (i *Infusion) Titrate(id string, in NewTitrationInput, by string, now time.Time) error {
	switch {
	case strings.TrimSpace(id) == "":
		return fmt.Errorf("%w: a titration needs an id", ErrInvalidEpisode)
	case !i.Running():
		return fmt.Errorf("%w: this infusion has stopped", ErrInvalidEpisode)
	case in.Rate < 0 || math.IsNaN(in.Rate) || math.IsInf(in.Rate, 0):
		return fmt.Errorf("%w: a rate is a non-negative number", ErrInvalidEpisode)
	case strings.TrimSpace(by) == "" && strings.TrimSpace(in.DeviceID) == "":
		return fmt.Errorf(
			"%w: a rate change names the nurse who made it or the pump that reported it",
			ErrInvalidEpisode)
	}

	effective := in.EffectiveAt
	if effective.IsZero() {
		effective = now
	}
	i.Titrations = append(i.Titrations, Titration{
		ID: strings.TrimSpace(id), Rate: in.Rate,
		RateUnit: strings.TrimSpace(in.RateUnit), Dose: in.Dose,
		EffectiveAt: effective.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by), DeviceID: strings.TrimSpace(in.DeviceID),
		Reason: strings.TrimSpace(in.Reason),
	})
	return nil
}

// Stop ends an infusion.
func (i *Infusion) Stop(by string, at time.Time) error {
	if !i.Running() {
		return fmt.Errorf("%w: this infusion has already stopped", ErrInvalidEpisode)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: stopping an infusion names who stopped it",
			ErrInvalidEpisode)
	}
	i.StoppedAt, i.StoppedBy = at.UTC(), strings.TrimSpace(by)
	return nil
}

// Running reports whether the infusion is still up.
func (i Infusion) Running() bool { return i.StoppedAt.IsZero() }

// CurrentDose is what the patient is getting now.
func (i Infusion) CurrentDose() (Titration, bool) {
	var best Titration
	found := false
	for _, t := range i.Titrations {
		if !found || t.EffectiveAt.After(best.EffectiveAt) {
			best, found = t, true
		}
	}
	return best, found
}

// Lines, tubes and drains (SRS-ICU-006).

// InvasiveDevice is a line, tube or drain in the patient.
type InvasiveDevice struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Kind is central line, arterial line, urinary catheter, ETT, chest drain.
	// The deployment's own vocabulary: SRS-IPC counts device days per kind,
	// and every surveillance definition names them differently.
	Kind string
	// Site is where — right internal jugular, left radial. Free text, because
	// a site is described rather than enumerated.
	Site string
	// Lumens matters for a central line; zero where it does not apply.
	Lumens int

	InsertedAt    time.Time
	InsertedBy    string
	RemovedAt     time.Time
	RemovedBy     string
	RemovalReason string

	// ReviewEvery is how often the unit reviews whether the device is still
	// needed. The single most effective control on device-associated
	// infection is asking daily whether the line can come out (SRS-ICU-006,
	// SRS-IPC).
	ReviewEvery    time.Duration
	LastReviewedAt time.Time
	LastReviewedBy string
}

// NewDeviceInput inserts an invasive device.
type NewDeviceInput struct {
	EpisodeID   string
	Kind        string
	Site        string
	Lumens      int
	InsertedAt  time.Time
	ReviewEvery time.Duration
}

// DefaultDeviceReview is how often a device is reviewed when the deployment
// has not said. Daily, which is the published bundle interval and the one a
// unit that has not configured anything should get.
const DefaultDeviceReview = 24 * time.Hour

// InsertDevice records a line, tube or drain going in (SRS-ICU-006).
func InsertDevice(id, tenantID string, in NewDeviceInput, by string, now time.Time) (
	InvasiveDevice, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return InvasiveDevice{}, fmt.Errorf("%w: a device belongs to an episode",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.Kind) == "":
		return InvasiveDevice{}, fmt.Errorf("%w: a device names what it is",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.Site) == "":
		// A central line with no site is one nobody can find to remove, and
		// site is half of every infection investigation.
		return InvasiveDevice{}, fmt.Errorf("%w: a device names its site",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return InvasiveDevice{}, fmt.Errorf("%w: an insertion names who performed it",
			ErrInvalidEpisode)
	}

	inserted := in.InsertedAt
	if inserted.IsZero() {
		inserted = now
	}
	review := in.ReviewEvery
	if review <= 0 {
		review = DefaultDeviceReview
	}
	return InvasiveDevice{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		Kind: strings.TrimSpace(in.Kind), Site: strings.TrimSpace(in.Site),
		Lumens:     in.Lumens,
		InsertedAt: inserted.UTC(), InsertedBy: strings.TrimSpace(by),
		ReviewEvery: review,
	}, nil
}

// Remove takes a device out.
func (d *InvasiveDevice) Remove(by, reason string, at time.Time) error {
	if !d.RemovedAt.IsZero() {
		return fmt.Errorf("%w: this device is already out", ErrInvalidEpisode)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a removal names who performed it", ErrInvalidEpisode)
	}
	if at.Before(d.InsertedAt) {
		return fmt.Errorf("%w: a device removed before it was inserted", ErrInvalidEpisode)
	}
	d.RemovedAt, d.RemovedBy = at.UTC(), strings.TrimSpace(by)
	d.RemovalReason = strings.TrimSpace(reason)
	return nil
}

// Review records that somebody asked whether the device can come out.
func (d *InvasiveDevice) Review(by string, at time.Time) error {
	if !d.RemovedAt.IsZero() {
		return fmt.Errorf("%w: this device is already out", ErrInvalidEpisode)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a review names who made it", ErrInvalidEpisode)
	}
	d.LastReviewedAt, d.LastReviewedBy = at.UTC(), strings.TrimSpace(by)
	return nil
}

// In reports whether the device is still in the patient.
func (d InvasiveDevice) In() bool { return d.RemovedAt.IsZero() }

// ReviewOverdue reports a device nobody has asked about (SRS-ICU-006).
//
// Measured from the last review or, where there has been none, from insertion.
// A device inserted two days ago and never reviewed is exactly the case the
// requirement's "overdue review can be derived" exists for.
func (d InvasiveDevice) ReviewOverdue(now time.Time) bool {
	if !d.In() || d.ReviewEvery <= 0 {
		return false
	}
	since := d.LastReviewedAt
	if since.IsZero() {
		since = d.InsertedAt
	}
	return now.Sub(since) > d.ReviewEvery
}

// DeviceDays counts days a device was in (SRS-ICU-017).
//
// Calendar days touched, matching SupportDays and every published
// device-day definition.
func DeviceDays(devices []InvasiveDevice, kind string, now time.Time) int {
	days := map[string]struct{}{}
	for _, device := range devices {
		if kind != "" && device.Kind != kind {
			continue
		}
		end := device.RemovedAt
		if end.IsZero() {
			end = now
		}
		for day := device.InsertedAt.UTC().Truncate(24 * time.Hour); !day.After(end); day = day.Add(24 * time.Hour) {
			days[device.Kind+"|"+day.Format(time.DateOnly)] = struct{}{}
		}
	}
	return len(days)
}
