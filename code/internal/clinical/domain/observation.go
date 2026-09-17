package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Observations, result flags and critical-result acknowledgement
// (SRS-CLN-005, SRS-CLN-011, SRS-CLN-012).
//
// The rule that shapes this file is SRS-CLN-011's, and it is unusually blunt:
// the UI "must not infer criticality independently". A chart that decides for
// itself whether a potassium of 6.1 is critical will disagree with the
// laboratory that measured it, and the disagreement will be invisible — two
// screens showing the same number with different urgency. So criticality
// arrives from the authoritative diagnostic service, travels with its
// provenance, and this context never computes it.

// ObservationStatus is how far a result has got.
type ObservationStatus string

const (
	// ObservationRegistered is expected but not yet resulted.
	ObservationRegistered ObservationStatus = "registered"
	// ObservationPreliminary is a result that may still change. Reported
	// because a preliminary blood culture at 2am changes treatment, and
	// withholding it until final would be worse.
	ObservationPreliminary ObservationStatus = "preliminary"
	ObservationFinal       ObservationStatus = "final"
	// ObservationAmended is a corrected result. The original stays, because a
	// clinician acted on it.
	ObservationAmended ObservationStatus = "amended"
	// ObservationCancelled was not performed.
	ObservationCancelled ObservationStatus = "cancelled"
	// ObservationEnteredInError was filed against the wrong patient.
	ObservationEnteredInError ObservationStatus = "entered_in_error"
)

var knownObservationStatuses = map[ObservationStatus]bool{
	ObservationRegistered: true, ObservationPreliminary: true,
	ObservationFinal: true, ObservationAmended: true,
	ObservationCancelled: true, ObservationEnteredInError: true,
}

// Interpretation is the authoritative service's reading of a value
// (SRS-CLN-011).
//
// Supplied, never derived. The laboratory knows its reference ranges, its
// analyser and its population; a chart guessing from a number does not.
type Interpretation string

const (
	InterpretationNormal Interpretation = "normal"
	InterpretationHigh   Interpretation = "high"
	InterpretationLow    Interpretation = "low"
	// InterpretationCriticalHigh and InterpretationCriticalLow are the ones
	// that must reach a clinician now, and whose acknowledgement is
	// SRS-CLN-012's subject.
	InterpretationCriticalHigh Interpretation = "critical_high"
	InterpretationCriticalLow  Interpretation = "critical_low"
	InterpretationAbnormal     Interpretation = "abnormal"
	// InterpretationUnknown is the honest answer when the service supplied
	// none. Distinct from normal: "nobody said" and "it is fine" are different
	// claims, and a chart that showed the second when it meant the first would
	// be reassuring about a result nobody assessed.
	InterpretationUnknown Interpretation = "unknown"
)

var knownInterpretations = map[Interpretation]bool{
	InterpretationNormal: true, InterpretationHigh: true, InterpretationLow: true,
	InterpretationCriticalHigh: true, InterpretationCriticalLow: true,
	InterpretationAbnormal: true, InterpretationUnknown: true,
}

// Critical reports an interpretation that must reach a clinician now.
func (i Interpretation) Critical() bool {
	return i == InterpretationCriticalHigh || i == InterpretationCriticalLow
}

// Abnormal reports anything the service did not call normal.
func (i Interpretation) Abnormal() bool {
	switch i {
	case InterpretationNormal, InterpretationUnknown:
		return false
	default:
		return true
	}
}

// Quantity is a measured value with its unit.
//
// Unit and value are inseparable. A potassium of 6.1 is a crisis in mmol/L and
// meaningless without it, and every system that has stored the number alone has
// eventually rendered one scale's value under another's label.
type Quantity struct {
	Value float64
	// Unit as the source reported it, in UCUM where the source uses UCUM.
	Unit string
}

// Observation is one measurement or finding (SRS-CLN-005).
type Observation struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// Code is what was measured.
	Code Coding
	// Value is the result. Exactly one of Quantity, Text or CodedValue is
	// meaningful; a blood pressure is a quantity, a blood group is a code, and
	// a microbiology comment is text.
	Value      Quantity
	TextValue  string
	CodedValue Coding
	// ReferenceLow and ReferenceHigh are the range the source used. Stored
	// rather than looked up, because the range depends on the analyser, the
	// method and the patient's age and sex — and a chart that applied today's
	// range to a five-year-old result would reinterpret history.
	ReferenceLow  *float64
	ReferenceHigh *float64
	ReferenceText string
	// Interpretation is the authoritative service's reading (SRS-CLN-011).
	Interpretation Interpretation
	// InterpretationSource names who said so, which the requirement calls flag
	// provenance. A chart showing "critical" with no source is a chart that
	// cannot answer "who decided this".
	InterpretationSource string

	Status ObservationStatus
	// EffectiveAt is when the observation was true of the patient — when blood
	// was drawn, not when the analyser finished. A trend built on the second
	// is a trend of laboratory throughput.
	EffectiveAt time.Time
	// IssuedAt is when the result was released.
	IssuedAt time.Time
	// PerformerID is who or what took it.
	PerformerID string
	// DeviceID names the analyser or monitor, where there was one. Kept
	// because a run of implausible values usually means one device, and
	// without this nobody can see that.
	DeviceID string
	// SourceSystem is where the result came from. Empty for something recorded
	// here; set for anything imported (SRS-CLN-010).
	SourceSystem string
	Note         string

	// Source and Validation together are SRS-ICU-003's "raw and device-derived
	// values are distinguishable from manually validated chart values". See
	// device.go: a device reading starts pending and only a named clinician
	// moves it, and SRS-ICU-009's scores read Validated() rather than the raw
	// list.
	Source     SourceKind
	Validation Validation
	// Device is the identity and quality metadata a device reading carries.
	// Zero for anything else.
	Device DeviceSource
	// ValidatedBy and ValidatedAt record the clinician who accepted or rejected
	// a device reading.
	ValidatedBy string
	ValidatedAt time.Time
	// ValidationNote is why a reading was rejected. A run of rejections with
	// reasons is how a failing probe gets found.
	ValidationNote string

	// AmendsID chains a corrected result to the one it replaces.
	AmendsID string

	RecordedBy string
	RecordedAt time.Time
	Version    int64
}

// NewObservation validates and constructs an observation.
func NewObservation(id, tenantID string, in NewObservationInput, recordedBy string,
	now time.Time) (Observation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Observation{}, fmt.Errorf("%w: observation id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return Observation{}, fmt.Errorf("%w: an observation needs a patient",
			ErrInvalidDocument)
	case !knownObservationStatuses[in.Status]:
		return Observation{}, fmt.Errorf("%w: unknown observation status %q",
			ErrInvalidDocument, in.Status)
	case !knownInterpretations[in.Interpretation]:
		return Observation{}, fmt.Errorf("%w: unknown interpretation %q",
			ErrInvalidDocument, in.Interpretation)
	case strings.TrimSpace(recordedBy) == "":
		return Observation{}, fmt.Errorf("%w: an observation must record its author",
			ErrInvalidDocument)
	}
	if err := in.Code.Validate(); err != nil {
		return Observation{}, err
	}

	// A quantity with no unit is a number nobody can safely read. The one
	// exception is a dimensionless count, which UCUM writes as "1".
	if in.Value.Value != 0 && strings.TrimSpace(in.Value.Unit) == "" {
		return Observation{}, fmt.Errorf(
			"%w: a measured value needs its unit; a potassium of 6.1 is a crisis "+
				"in mmol/L and meaningless without it", ErrInvalidDocument)
	}

	// An interpretation with no source cannot answer "who decided this", and
	// SRS-CLN-011 asks for flag provenance to be visible.
	if in.Interpretation != InterpretationUnknown &&
		strings.TrimSpace(in.InterpretationSource) == "" {
		return Observation{}, fmt.Errorf(
			"%w: an interpretation must name the service that made it",
			ErrInvalidDocument)
	}

	effective := in.EffectiveAt
	if effective.IsZero() {
		effective = now
	}
	if effective.After(now.Add(time.Minute)) {
		// A minute of slack for clock skew between a bedside monitor and the
		// server; beyond that it is a typo, and it would sort to the top of
		// every trend for as long as it stood.
		return Observation{}, fmt.Errorf("%w: an observation cannot be true in the future",
			ErrInvalidDocument)
	}

	// SRS-ICU-003. The source decides the starting validation state, and
	// nothing else may set it: a caller that could pass "confirmed" in with
	// the reading would be able to walk a device value straight into a score.
	source := in.Source
	if source == "" {
		// An observation whose caller said nothing about its source is a
		// person typing at a keyboard — every Wave-1 path, and every path
		// written before this field existed. Device ingestion says so
		// explicitly.
		source = SourceManual
	}
	if !KnownSourceKind(string(source)) {
		return Observation{}, fmt.Errorf("%w: unknown observation source %q",
			ErrInvalidDocument, source)
	}
	if source == SourceDevice {
		if err := in.Device.Validate(); err != nil {
			return Observation{}, err
		}
	}

	return Observation{
		ID: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, Code: in.Code, Value: in.Value,
		TextValue: strings.TrimSpace(in.TextValue), CodedValue: in.CodedValue,
		ReferenceLow: in.ReferenceLow, ReferenceHigh: in.ReferenceHigh,
		ReferenceText:  in.ReferenceText,
		Interpretation: in.Interpretation, InterpretationSource: in.InterpretationSource,
		Status: in.Status, EffectiveAt: effective.UTC(), IssuedAt: in.IssuedAt.UTC(),
		PerformerID: in.PerformerID, DeviceID: in.DeviceID,
		SourceSystem: in.SourceSystem, Note: strings.TrimSpace(in.Note),
		Source: source, Validation: DefaultValidationFor(source), Device: in.Device,
		RecordedBy: recordedBy, RecordedAt: now.UTC(), Version: 1,
	}, nil
}

// NewObservationInput is what recording an observation needs.
type NewObservationInput struct {
	PatientID            string
	EncounterID          string
	Code                 Coding
	Value                Quantity
	TextValue            string
	CodedValue           Coding
	ReferenceLow         *float64
	ReferenceHigh        *float64
	ReferenceText        string
	Interpretation       Interpretation
	InterpretationSource string
	Status               ObservationStatus
	EffectiveAt          time.Time
	IssuedAt             time.Time
	PerformerID          string
	DeviceID             string
	SourceSystem         string
	Note                 string
	// Source says where the reading came from (SRS-ICU-003). Empty means a
	// person typed it, which is what every path written before device
	// ingestion existed was doing.
	Source SourceKind
	// Device is the identity and quality metadata, required when Source is
	// SourceDevice.
	Device DeviceSource
}

// External reports a result that came from somewhere else (SRS-CLN-010).
func (o Observation) External() bool { return strings.TrimSpace(o.SourceSystem) != "" }

// Live reports an observation that still stands.
func (o Observation) Live() bool {
	return o.Status != ObservationCancelled && o.Status != ObservationEnteredInError
}

// NeedsAcknowledgement reports a result that must reach a clinician now
// (SRS-CLN-012).
func (o Observation) NeedsAcknowledgement() bool {
	return o.Live() && o.Interpretation.Critical()
}

// ObservationList is a set of results.
type ObservationList []Observation

// Trend returns one code's live results in time order, oldest first.
//
// Oldest first, unlike everything else here: a trend is read left to right, and
// a reversed series is one a clinician has to re-sort in their head.
func (l ObservationList) Trend(system, code string) ObservationList {
	out := make(ObservationList, 0, len(l))
	for _, o := range l {
		if o.Live() && o.Code.System == system && o.Code.Code == code {
			out = append(out, o)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].EffectiveAt.Before(out[j].EffectiveAt)
	})
	return out
}

// Critical returns the live results that need acknowledging.
func (l ObservationList) Critical() ObservationList {
	out := make(ObservationList, 0)
	for _, o := range l {
		if o.NeedsAcknowledgement() {
			out = append(out, o)
		}
	}
	return out
}

// CriticalAcknowledgement records a clinician acting on a critical result
// (SRS-CLN-012).
//
// The action is mandatory, not just the acknowledgement. "Seen" is not a
// clinical response to a potassium of 6.9, and a system that accepted a
// bare click would produce a complete acknowledgement log alongside a dead
// patient.
type CriticalAcknowledgement struct {
	ID             string
	TenantID       string
	ObservationID  string
	PatientID      string
	AcknowledgedBy string
	AcknowledgedAt time.Time
	// Action is what the clinician did about it.
	Action string
	// NotifiedAt is when the result was first made known to somebody, which is
	// what an escalation clock runs from. Distinct from when it was
	// acknowledged: the gap between them is the number a safety review wants.
	NotifiedAt time.Time
}

// MinAcknowledgementActionLength stops "ok" from counting as a clinical
// response.
//
// A crude rule, deliberately: the alternative is a free-text field that fills
// with single characters, which is indistinguishable from no control at all.
const MinAcknowledgementActionLength = 10

// NewCriticalAcknowledgement validates and constructs an acknowledgement.
func NewCriticalAcknowledgement(id, tenantID, observationID, patientID, by,
	action string, notifiedAt, now time.Time) (CriticalAcknowledgement, error) {

	action = strings.TrimSpace(action)

	switch {
	case strings.TrimSpace(id) == "":
		return CriticalAcknowledgement{}, fmt.Errorf("%w: acknowledgement id is required",
			ErrInvalidDocument)
	case strings.TrimSpace(observationID) == "":
		return CriticalAcknowledgement{}, fmt.Errorf(
			"%w: an acknowledgement needs a result", ErrInvalidDocument)
	case strings.TrimSpace(by) == "":
		return CriticalAcknowledgement{}, fmt.Errorf(
			"%w: an acknowledgement needs the clinician who made it", ErrInvalidDocument)
	case len(action) < MinAcknowledgementActionLength:
		return CriticalAcknowledgement{}, fmt.Errorf(
			"%w: acknowledging a critical result needs the action taken, "+
				"at least %d characters", ErrInvalidDocument,
			MinAcknowledgementActionLength)
	}

	return CriticalAcknowledgement{
		ID: id, TenantID: tenantID, ObservationID: observationID,
		PatientID: patientID, AcknowledgedBy: by, AcknowledgedAt: now.UTC(),
		Action: action, NotifiedAt: notifiedAt.UTC(),
	}, nil
}

// Delay is how long the result went unacknowledged, and whether that is known.
func (a CriticalAcknowledgement) Delay() (time.Duration, bool) {
	if a.NotifiedAt.IsZero() {
		return 0, false
	}
	return a.AcknowledgedAt.Sub(a.NotifiedAt), true
}

// EscalationPolicy is when an unacknowledged critical result is escalated
// (SRS-CLN-012).
type EscalationPolicy struct {
	// After is how long a critical result may sit unacknowledged.
	After time.Duration
	// Then is how long after escalating before it escalates again.
	Then time.Duration
	// MaxEscalations bounds the chain. Unbounded escalation ends at the chief
	// executive's phone at 3am for a result somebody is already acting on.
	MaxEscalations int
}

// DefaultEscalationPolicy escalates after fifteen minutes, then every fifteen,
// up to three times.
//
// Fifteen minutes because that is roughly how long a laboratory will spend
// trying to reach somebody by phone before it becomes their problem, and
// because a policy measured in hours is a policy that has already failed for a
// potassium of 7.
func DefaultEscalationPolicy() EscalationPolicy {
	return EscalationPolicy{After: 15 * time.Minute, Then: 15 * time.Minute, MaxEscalations: 3}
}

// Validate rejects a policy that could not be applied.
func (p EscalationPolicy) Validate() error {
	switch {
	case p.After <= 0:
		return fmt.Errorf("%w: an escalation policy needs a delay", ErrInvalidDocument)
	case p.MaxEscalations < 0:
		return fmt.Errorf("%w: an escalation count cannot be negative", ErrInvalidDocument)
	}
	return nil
}

// DueEscalations reports how many times an unacknowledged result should have
// escalated by an instant.
//
// Computed rather than stored so a policy change takes effect on results
// already outstanding, which is the point of changing it.
func (p EscalationPolicy) DueEscalations(notifiedAt, at time.Time) int {
	if notifiedAt.IsZero() || p.After <= 0 {
		return 0
	}
	elapsed := at.Sub(notifiedAt)
	if elapsed < p.After {
		return 0
	}
	count := 1
	if p.Then > 0 {
		count += int((elapsed - p.After) / p.Then)
	}
	if p.MaxEscalations > 0 && count > p.MaxEscalations {
		count = p.MaxEscalations
	}
	return count
}
