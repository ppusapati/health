package domain

import (
	"strings"
	"time"
)

// Shift handover (SRS-NUR-010).
//
// The acceptance criterion is that the acknowledgement and the shift are
// recorded, which is a statement about what handover is *for*. A handover is
// the moment responsibility for a patient moves from one person to another,
// and the record's job is to show that it moved — that somebody accepted it —
// not merely that something was said.
//
// So a handover is a stored snapshot rather than a screen that renders the
// current state. Rendered live, the "handover" the incoming nurse acknowledged
// at 20:00 shows something different at 23:00, and nobody can say afterwards
// what they were told. Stored, it is evidence.

// Shift names the working period a handover runs between.
type Shift struct {
	// Code is the ward's own name for it: "day", "night", "early", "late".
	Code string
	// StartsAt and EndsAt bound it. Stored on the handover rather than derived
	// from a roster, because rosters change and a handover from six months ago
	// must still say which hours it covered.
	StartsAt time.Time
	EndsAt   time.Time
}

// Handover is one shift's handover for one patient (SRS-NUR-010).
type Handover struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	UnitID      string

	FromShift Shift
	ToShift   Shift

	// Situation, Background, Assessment and Recommendation are the structure
	// the requirement asks for, in the form nursing actually uses. Structured
	// fields rather than one free-text box, because a free box gets a sentence
	// and the structure is what makes the omissions visible.
	Situation      string
	Background     string
	Assessment     string
	Recommendation string

	// CriticalRisks, Devices and PendingTasks are the four named contents of
	// SRS-NUR-010, captured as they stood when the handover was composed.
	CriticalRisks    []string
	Devices          []HandoverDevice
	PendingTasks     []HandoverTask
	OutstandingIssue []string

	ComposedAt time.Time
	ComposedBy string

	// AcknowledgedAt and AcknowledgedBy are the requirement's acceptance
	// criterion, and the reason the handover is a record rather than a report.
	AcknowledgedAt time.Time
	AcknowledgedBy string
	// Questions are what the incoming nurse asked on accepting. Recorded
	// because an unanswered question at handover is where things go wrong.
	Questions string

	Version int64
}

// HandoverDevice is a device as it stood at handover.
type HandoverDevice struct {
	DeviceID   string
	Kind       DeviceKind
	Site       string
	InsertedAt time.Time
	DeviceDays int
}

// HandoverTask is an outstanding task as it stood at handover.
type HandoverTask struct {
	TaskID      string
	Description string
	Priority    TaskPriority
	DueAt       time.Time
	Overdue     bool
}

// NewHandoverInput is what composing a handover needs.
type NewHandoverInput struct {
	PatientID        string
	EncounterID      string
	UnitID           string
	FromShift        Shift
	ToShift          Shift
	Situation        string
	Background       string
	Assessment       string
	Recommendation   string
	CriticalRisks    []string
	Devices          []HandoverDevice
	PendingTasks     []HandoverTask
	OutstandingIssue []string
}

// NewHandover composes a handover.
func NewHandover(id, tenantID string, in NewHandoverInput, composedBy string,
	now time.Time) (*Handover, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a handover needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a handover needs an encounter")
	}
	if strings.TrimSpace(composedBy) == "" {
		return nil, invalidf("a handover must record who gave it")
	}
	if strings.TrimSpace(in.FromShift.Code) == "" ||
		strings.TrimSpace(in.ToShift.Code) == "" {
		// SRS-NUR-010: the shift is recorded. A handover that does not say
		// which shift handed to which cannot establish who held the patient at
		// any given hour, which is the question an incident review asks first.
		return nil, invalidf("a handover must name the shift it is between")
	}
	if strings.TrimSpace(in.Situation) == "" {
		return nil, invalidf("a handover needs the patient's current situation")
	}
	if strings.TrimSpace(in.Recommendation) == "" {
		// The recommendation is the part the incoming nurse acts on. A
		// handover that describes without recommending hands over information
		// but not the work.
		return nil, invalidf("a handover needs what the incoming shift should do")
	}

	return &Handover{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		UnitID:    strings.TrimSpace(in.UnitID),
		FromShift: in.FromShift, ToShift: in.ToShift,
		Situation:        strings.TrimSpace(in.Situation),
		Background:       strings.TrimSpace(in.Background),
		Assessment:       strings.TrimSpace(in.Assessment),
		Recommendation:   strings.TrimSpace(in.Recommendation),
		CriticalRisks:    append([]string(nil), in.CriticalRisks...),
		Devices:          append([]HandoverDevice(nil), in.Devices...),
		PendingTasks:     append([]HandoverTask(nil), in.PendingTasks...),
		OutstandingIssue: append([]string(nil), in.OutstandingIssue...),
		ComposedAt:       now.UTC(), ComposedBy: composedBy, Version: 1,
	}, nil
}

// Acknowledge records the incoming nurse accepting the handover
// (SRS-NUR-010).
func (h *Handover) Acknowledge(by, questions string, now time.Time) error {
	if h.Acknowledged() {
		return notAllowedf("this handover has already been acknowledged by %s",
			h.AcknowledgedBy)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("acknowledging a handover must record who accepted it")
	}
	if strings.EqualFold(strings.TrimSpace(by), strings.TrimSpace(h.ComposedBy)) {
		// A nurse acknowledging their own handover is not a handover. It is
		// one person marking their own work received, and it would let a shift
		// end with the record showing a transfer that never happened.
		return invalidf("a handover must be acknowledged by somebody other than the nurse who gave it")
	}
	h.AcknowledgedAt = now.UTC()
	h.AcknowledgedBy = by
	h.Questions = strings.TrimSpace(questions)
	h.Version++
	return nil
}

// Acknowledged reports whether responsibility has actually moved.
func (h *Handover) Acknowledged() bool { return !h.AcknowledgedAt.IsZero() }

// Unacknowledged reports a handover that was given and never accepted.
//
// Visible as its own state rather than quietly ageing, because an
// unacknowledged handover means a patient whose care nobody has taken
// responsibility for — which is the situation the record exists to surface.
func (h *Handover) Unacknowledged(now time.Time, after time.Duration) bool {
	return !h.Acknowledged() && now.UTC().Sub(h.ComposedAt) > after
}
