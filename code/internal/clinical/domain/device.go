package domain

import (
	"fmt"
	"strings"
	"time"
)

// Device-sourced observations (SRS-ICU-003, with SRS-ICU-002 and SRS-ICU-009).
//
// SRS-ICU-003 asks for bedside monitor values to be ingested "with device
// identity and quality/source metadata", and verifies it with the sentence
// this whole file exists to make true: **raw and device-derived values are
// distinguishable from manually validated chart values.**
//
// That distinction is not bookkeeping. A bedside monitor produces a reading
// every few seconds, and a great many of them are wrong in ways a human reads
// past without noticing: a saturation probe off a finger reads 60%, an
// arterial line being flushed reads a systolic of 300, a patient turning over
// reads asystole. A nurse looking at the bedside sees a patient who is fine
// and ignores it. A chart that quietly absorbed those numbers would carry all
// of them as fact, and the two consumers that read a chart rather than a
// patient — the trend and the score — would be computed from artefacts.
//
// SRS-ICU-009 makes the consequence explicit: scores are calculated "only from
// explicit validated inputs". So this is load-bearing rather than decorative,
// and the rule it enforces is one-directional: a device value becomes a chart
// value only when a named human says so, and nothing else in the system may
// perform that conversion.

// SourceKind is where an observation came from.
type SourceKind string

const (
	// SourceManual was typed by a person who was looking at the patient. It is
	// validated by construction: the human was the instrument.
	SourceManual SourceKind = "manual"
	// SourceDevice came off a monitor or analyser at the bedside.
	SourceDevice SourceKind = "device"
	// SourceImported arrived from another system that is authoritative for it
	// — a laboratory, another hospital (SRS-CLN-010). Validated where it
	// arrived, not here.
	SourceImported SourceKind = "imported"
	// SourceUnknown is a stored value this build cannot classify. Treated as
	// unvalidated wherever it matters, which is the safe direction: a reading
	// nobody can attribute must not feed a score.
	SourceUnknown SourceKind = "unknown"
)

var knownSourceKinds = map[SourceKind]bool{
	SourceManual: true, SourceDevice: true,
	SourceImported: true, SourceUnknown: true,
}

// KnownSourceKind reports whether a stored value is one this build handles.
func KnownSourceKind(raw string) bool { return knownSourceKinds[SourceKind(raw)] }

// Validation is whether a human has accepted a reading into the chart.
type Validation string

const (
	// ValidationNotRequired is a value whose source is already authoritative —
	// a typed measurement, a released laboratory result. Nobody has to confirm
	// what a person already asserted.
	ValidationNotRequired Validation = "not_required"
	// ValidationPending is a device reading nobody has confirmed. It is
	// visible on the chart and excluded from anything computed.
	ValidationPending Validation = "pending"
	// ValidationConfirmed is a device reading a named clinician accepted.
	ValidationConfirmed Validation = "confirmed"
	// ValidationRejected is a device reading a clinician marked as an artefact
	// — the probe was off, the line was being flushed. Kept rather than
	// deleted: a run of rejected readings is how a failing probe is found, and
	// deleting them hides the pattern that would have found it.
	ValidationRejected Validation = "rejected"
)

var knownValidations = map[Validation]bool{
	ValidationNotRequired: true, ValidationPending: true,
	ValidationConfirmed: true, ValidationRejected: true,
}

// KnownValidation reports whether a stored value is one this build handles.
func KnownValidation(raw string) bool { return knownValidations[Validation(raw)] }

// DefaultValidationFor is the state a newly recorded observation starts in.
//
// The whole rule in one function: anything off a device starts pending, and
// anything a human or an authoritative system asserted does not need
// confirming. A device value can only leave `pending` through Confirm or
// Reject below, both of which demand a named clinician.
func DefaultValidationFor(source SourceKind) Validation {
	if source == SourceDevice || source == SourceUnknown {
		return ValidationPending
	}
	return ValidationNotRequired
}

// DeviceSource is the identity and quality metadata a reading arrives with
// (SRS-ICU-003).
type DeviceSource struct {
	// DeviceID is the monitor. Required for a device reading: a run of
	// implausible values almost always means one device, and a reading that
	// cannot name its device is one nobody can trace to the probe that caused
	// it.
	DeviceID string
	// Channel is which parameter of the device this came from — "SpO2",
	// "ART". A monitor produces several streams and they fail independently.
	Channel string
	// Quality is what the device said about its own signal, verbatim: "good",
	// "artefact", "searching". A string rather than an enum because every
	// vendor has its own vocabulary, and normalising it here would lose the
	// distinction between "the device said nothing" and "the device said a
	// word we do not know".
	Quality string
	// ObservedAt is the device's own timestamp for the reading.
	ObservedAt time.Time
	// ReceivedAt is when it reached us. Separate from ObservedAt because the
	// gap between them is the thing that makes a feed stale, and a single
	// timestamp cannot show it.
	ReceivedAt time.Time
}

// Validate rejects device metadata that could not be traced.
func (d DeviceSource) Validate() error {
	switch {
	case strings.TrimSpace(d.DeviceID) == "":
		return fmt.Errorf("%w: a device reading names the device it came from",
			ErrInvalidDocument)
	case d.ObservedAt.IsZero():
		return fmt.Errorf("%w: a device reading carries the device's own timestamp",
			ErrInvalidDocument)
	}
	return nil
}

// Lag is how long the reading took to arrive, and whether that is knowable.
func (d DeviceSource) Lag() (time.Duration, bool) {
	if d.ObservedAt.IsZero() || d.ReceivedAt.IsZero() {
		return 0, false
	}
	return d.ReceivedAt.Sub(d.ObservedAt), true
}

// DefaultStaleAfter is when a silent feed stops being trusted.
//
// Two minutes. A bedside monitor reports every few seconds, so two minutes of
// silence is not a quiet patient — it is a disconnected cable, a monitor in
// standby, or an interface that has stopped. SRS-ICU-012 requires the dashboard
// to mark it, and SRS-OPSNFR-001 requires the screen to keep working while it
// is marked: a ward that cannot chart because a feed died is a ward that goes
// back to paper.
const DefaultStaleAfter = 2 * time.Minute

// FeedStale reports whether a feed's most recent reading is too old to trust.
//
// Stale on a zero timestamp, deliberately. "We have never heard from this
// device" and "we have not heard from it lately" are the same thing to a
// clinician deciding whether to believe a number on a screen, and the
// dangerous reading of a zero value is "fresh".
func FeedStale(lastReadingAt, now time.Time, after time.Duration) bool {
	if after <= 0 {
		after = DefaultStaleAfter
	}
	if lastReadingAt.IsZero() {
		return true
	}
	return now.Sub(lastReadingAt) > after
}

// Confirm accepts a device reading into the chart (SRS-ICU-003).
//
// The only way a device value becomes a chart value, and it needs a named
// clinician. Everything else in the system that wants a validated value has to
// wait for one of these.
func (o *Observation) Confirm(by string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: confirming a reading names who confirmed it",
			ErrInvalidDocument)
	}
	switch o.Validation {
	case ValidationNotRequired:
		return fmt.Errorf("%w: this value was not device-derived and needs no confirmation",
			ErrInvalidDocument)
	case ValidationRejected:
		// Not reversible here. A clinician who rejected a reading and then
		// changed their mind records a fresh observation, so the chart shows
		// both decisions and when each was made rather than only the last.
		return fmt.Errorf("%w: this reading was rejected as an artefact; record it again "+
			"if it was real", ErrInvalidDocument)
	case ValidationConfirmed:
		return nil
	}

	o.Validation = ValidationConfirmed
	o.ValidatedBy = strings.TrimSpace(by)
	o.ValidatedAt = at.UTC()
	return nil
}

// Reject marks a device reading as an artefact (SRS-ICU-003).
func (o *Observation) Reject(by, reason string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: rejecting a reading names who rejected it",
			ErrInvalidDocument)
	}
	if strings.TrimSpace(reason) == "" {
		// "Artefact" with no reason cannot be told from a mis-click, and the
		// reason is what makes a run of rejections diagnosable.
		return fmt.Errorf("%w: rejecting a reading needs a reason",
			ErrInvalidDocument)
	}
	switch o.Validation {
	case ValidationNotRequired:
		return fmt.Errorf("%w: this value was not device-derived; correct it with an "+
			"amendment instead", ErrInvalidDocument)
	case ValidationConfirmed:
		return fmt.Errorf("%w: this reading was already confirmed into the chart; "+
			"amend it instead", ErrInvalidDocument)
	case ValidationRejected:
		return nil
	}

	o.Validation = ValidationRejected
	o.ValidatedBy = strings.TrimSpace(by)
	o.ValidatedAt = at.UTC()
	o.ValidationNote = strings.TrimSpace(reason)
	return nil
}

// Validated reports a value a computation may use (SRS-ICU-009).
//
// The single predicate everything derived has to go through. A reading that is
// pending, rejected, or from a source this build cannot classify is not
// validated, and none of those three may reach a score.
func (o Observation) Validated() bool {
	return o.Live() && (o.Validation == ValidationNotRequired ||
		o.Validation == ValidationConfirmed)
}

// Provisional reports a reading shown on the chart and excluded from anything
// computed.
func (o Observation) Provisional() bool {
	return o.Live() && o.Validation == ValidationPending
}

// ValidatedInputs filters a set down to what a score may be calculated from
// (SRS-ICU-009).
//
// A function rather than a convention, because "only from explicit validated
// inputs" is the kind of rule that is followed everywhere until the one place
// somebody reaches for the raw list.
func (l ObservationList) ValidatedInputs() ObservationList {
	out := make(ObservationList, 0, len(l))
	for _, observation := range l {
		if observation.Validated() {
			out = append(out, observation)
		}
	}
	return out
}
