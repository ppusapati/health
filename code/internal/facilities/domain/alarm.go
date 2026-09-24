package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Severity is how loud a facility alarm is (SRS-FAC-005, SRS-FAC-006).
type Severity string

const (
	// SeverityCritical is a condition somebody is woken for: low oxygen
	// pressure, a fire panel in alarm, mains and generator both down.
	SeverityCritical Severity = "critical"
	SeverityMajor    Severity = "major"
	SeverityMinor    Severity = "minor"
	// SeverityInfo is a state change worth recording and not worth
	// telling anybody about — a pump changing over on schedule.
	SeverityInfo Severity = "info"
)

var knownSeverity = map[Severity]bool{
	SeverityCritical: true, SeverityMajor: true,
	SeverityMinor: true, SeverityInfo: true,
}

func (s Severity) rank() int {
	switch s {
	case SeverityCritical:
		return 0
	case SeverityMajor:
		return 1
	case SeverityMinor:
		return 2
	default:
		return 3
	}
}

// AtLeast reports whether this severity is as loud as another.
func (s Severity) AtLeast(other Severity) bool {
	return s.rank() <= other.rank()
}

// AlarmState is what the plant is currently saying (SRS-FAC-005).
//
// Two states, not three, and acknowledgement is deliberately not one of them.
// An alarm is active or it has cleared; whether a human has seen it is a
// separate fact recorded separately, because an alarm that is still sounding
// and has been acknowledged is a real and common situation, and a single state
// field forces it to be misfiled as one or the other.
type AlarmState string

const (
	AlarmActive  AlarmState = "active"
	AlarmCleared AlarmState = "cleared"
)

var knownAlarmState = map[AlarmState]bool{
	AlarmActive: true, AlarmCleared: true,
}

// Alarm is one event from a facility gateway (SRS-FAC-005).
//
// The important thing about this type is what is not in it. There is no work
// order state, no assignee, no completion note and no closure. SRS-FAC-005
// asks that the alarm and the maintenance lifecycle stay linked but distinct,
// and the way to guarantee that is for neither row to be able to express the
// other's lifecycle. An alarm that cleared because the pressure came back and
// a work order somebody completed are different facts about different things,
// and a schema that let one column carry both would eventually be asked which
// one it meant.
type Alarm struct {
	ID       string
	TenantID string

	// GatewayID and PointRef identify where in the plant this came from:
	// which SCADA gateway, and which point on it.
	GatewayID string
	PointRef  string
	// ExternalID is the gateway's own identifier for the event. A gateway
	// that reconnects after a network drop and replays its buffer must
	// not produce a second alarm, so this is unique per gateway and the
	// database says so.
	ExternalID string

	AssetID    string
	FacilityID string
	System     System
	Severity   Severity
	// Message is the gateway's text. Kept as it arrived: a rewritten
	// alarm message is one that cannot be matched against the panel.
	Message string

	Source    Source
	RaisedAt  time.Time
	ClearedAt time.Time
	State     AlarmState

	AcknowledgedAt time.Time
	AcknowledgedBy string

	// WorkOrderID is the link SRS-FAC-005 asks for, and it lives here
	// rather than on the work order. One side only: a link stored on both
	// rows is a link that can disagree with itself, and the question
	// worth answering quickly — "did anybody do anything about this
	// alarm" — is the one this direction answers.
	WorkOrderID string
	LinkedAt    time.Time
	LinkedBy    string

	CreatedAt time.Time
	Version   int64
}

// Open reports whether the plant is still asserting this alarm.
func (a Alarm) Open() bool { return a.State == AlarmActive }

// Acknowledged reports whether a person has seen it.
func (a Alarm) Acknowledged() bool { return !a.AcknowledgedAt.IsZero() }

// IngestInput is one alarm as the gateway reported it.
type IngestInput struct {
	GatewayID  string
	PointRef   string
	ExternalID string
	AssetID    string
	FacilityID string
	System     System
	Severity   Severity
	Message    string
	Source     Source
	RaisedAt   time.Time
}

// Ingest records a facility alarm from a gateway (SRS-FAC-005).
func Ingest(id, tenantID string, in IngestInput, now time.Time) (Alarm, error) {
	switch {
	case strings.TrimSpace(id) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.GatewayID) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm names its gateway",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.PointRef) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm names its point",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.ExternalID) == "":
		// Without the gateway's own identifier there is no way to
		// recognise a replayed event, and a gateway reconnecting after
		// an outage replays everything it buffered.
		return Alarm{}, fmt.Errorf("%w: an alarm carries the gateway's event id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Message) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm needs its message",
			ErrInvalidFacilities)
	case !knownSystem[in.System]:
		return Alarm{}, fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, in.System)
	case !knownSeverity[in.Severity]:
		return Alarm{}, fmt.Errorf("%w: unknown severity %q",
			ErrInvalidFacilities, in.Severity)
	case !knownSource[in.Source]:
		return Alarm{}, fmt.Errorf("%w: unknown source %q",
			ErrInvalidFacilities, in.Source)
	case in.Source == SourceManual:
		// A person who has noticed something wrong raises a work
		// order. Letting somebody type an alarm would put fabricated
		// plant events into the record the command centre trusts
		// because it came off the gateway.
		return Alarm{}, fmt.Errorf("%w: alarms come from plant, not people",
			ErrInvalidFacilities)
	case in.RaisedAt.IsZero():
		return Alarm{}, fmt.Errorf("%w: an alarm says when it was raised",
			ErrInvalidFacilities)
	case in.RaisedAt.After(now.Add(time.Hour)):
		return Alarm{}, fmt.Errorf("%w: that alarm is in the future",
			ErrInvalidFacilities)
	}

	return Alarm{
		ID: id, TenantID: tenantID,
		GatewayID:  strings.TrimSpace(in.GatewayID),
		PointRef:   strings.TrimSpace(in.PointRef),
		ExternalID: strings.TrimSpace(in.ExternalID),
		AssetID:    strings.TrimSpace(in.AssetID),
		FacilityID: strings.TrimSpace(in.FacilityID),
		System:     in.System, Severity: in.Severity,
		Message:  strings.TrimSpace(in.Message),
		Source:   in.Source,
		RaisedAt: in.RaisedAt.UTC(), State: AlarmActive,
		CreatedAt: now.UTC(), Version: 1,
	}, nil
}

// Clear records the plant no longer asserting the alarm (SRS-FAC-005).
//
// It touches nothing about the work order. A chiller whose alarm cleared
// because somebody cycled the power has not been repaired, and the work order
// is what says whether it has.
func (a *Alarm) Clear(now time.Time) error {
	if a.State != AlarmActive {
		return fmt.Errorf("%w: this alarm has already cleared",
			ErrInvalidFacilities)
	}
	a.State = AlarmCleared
	a.ClearedAt = now.UTC()
	return nil
}

// AcknowledgeAlarm records a person seeing it (SRS-FAC-005).
//
// Allowed on a cleared alarm on purpose. A pressure dip at 3am that cleared
// itself still needs somebody to have looked at it, and refusing the
// acknowledgement would mean the only alarms anybody can be shown to have
// read are the ones that were still sounding when they got there.
func (a *Alarm) AcknowledgeAlarm(by string, now time.Time) error {
	switch {
	case a.Acknowledged():
		return fmt.Errorf("%w: %s has already acknowledged this alarm",
			ErrInvalidFacilities, a.AcknowledgedBy)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who acknowledged the alarm",
			ErrInvalidFacilities)
	}
	a.AcknowledgedAt = now.UTC()
	a.AcknowledgedBy = strings.TrimSpace(by)
	return nil
}

// LinkWork attaches the work raised for an alarm (SRS-FAC-005).
//
// Once. Repointing an alarm at a different work order would rewrite history:
// the question "what did we do about the gas alarm on the 14th" has one
// answer, and it is whichever order was raised at the time.
func (a *Alarm) LinkWork(workOrderID, by string, now time.Time) error {
	switch {
	case strings.TrimSpace(workOrderID) == "":
		return fmt.Errorf("%w: name the work order",
			ErrInvalidFacilities)
	case a.WorkOrderID != "" &&
		a.WorkOrderID != strings.TrimSpace(workOrderID):
		return fmt.Errorf("%w: this alarm is already linked to %s",
			ErrInvalidFacilities, a.WorkOrderID)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who linked the work",
			ErrInvalidFacilities)
	}
	if a.WorkOrderID != "" {
		return nil
	}
	a.WorkOrderID = strings.TrimSpace(workOrderID)
	a.LinkedAt = now.UTC()
	a.LinkedBy = strings.TrimSpace(by)
	return nil
}

// AlarmRule is the configuration SRS-FAC-005's "when configured" refers to.
//
// A hospital that wires every informational state change to a work order
// produces a thousand tickets a week and stops reading any of them. So the
// rule says which system, how loud, and what the resulting work looks like,
// and an alarm that matches nothing is recorded and left alone.
type AlarmRule struct {
	TenantID   string
	FacilityID string
	System     System
	// MinSeverity is the quietest alarm that raises work.
	MinSeverity Severity
	// Priority and ClassCode shape the work order. A rule that raised
	// routine work for a critical gas alarm would satisfy the requirement
	// and defeat the point.
	Priority  Priority
	ClassCode string
	// OwnerTeam routes the generated order.
	OwnerTeam string
	Active    bool
}

// Validate rejects a rule that could not be applied.
func (r AlarmRule) Validate() error {
	switch {
	case !knownSystem[r.System]:
		return fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, r.System)
	case !knownSeverity[r.MinSeverity]:
		return fmt.Errorf("%w: unknown severity %q",
			ErrInvalidFacilities, r.MinSeverity)
	case !knownPriority[r.Priority]:
		return fmt.Errorf("%w: unknown priority %q",
			ErrInvalidFacilities, r.Priority)
	case strings.TrimSpace(r.ClassCode) == "":
		return fmt.Errorf("%w: an alarm rule names the work class",
			ErrInvalidFacilities)
	case strings.TrimSpace(r.OwnerTeam) == "":
		return fmt.Errorf("%w: an alarm rule names who the work goes to",
			ErrInvalidFacilities)
	}
	return nil
}

// Matches reports whether a rule applies to an alarm (SRS-FAC-005).
func (r AlarmRule) Matches(a Alarm) bool {
	if !r.Active || r.System != a.System {
		return false
	}
	if r.FacilityID != "" && r.FacilityID != a.FacilityID {
		return false
	}
	return a.Severity.AtLeast(r.MinSeverity)
}

// RuleFor picks the rule that applies to an alarm (SRS-FAC-005).
//
// The most specific match wins: a rule for this facility beats a tenant-wide
// one, and among equals the one demanding the loudest alarm, because that is
// the more deliberately configured of the two.
func RuleFor(rules []AlarmRule, a Alarm) (AlarmRule, bool) {
	matched := make([]AlarmRule, 0, len(rules))
	for _, rule := range rules {
		if rule.Matches(a) {
			matched = append(matched, rule)
		}
	}
	if len(matched) == 0 {
		return AlarmRule{}, false
	}
	sort.SliceStable(matched, func(i, j int) bool {
		si := matched[i].FacilityID != ""
		sj := matched[j].FacilityID != ""
		if si != sj {
			return si
		}
		return matched[i].MinSeverity.rank() < matched[j].MinSeverity.rank()
	})
	return matched[0], true
}

// AlarmWork describes the work order an alarm should raise (SRS-FAC-005).
type AlarmWork struct {
	System    System
	Priority  Priority
	ClassCode string
	OwnerTeam string
	AssetID   string
	Fault     string
	Impact    string
}

// WorkFor turns a matched alarm into a work order request (SRS-FAC-005).
//
// The impact line is generated and says so. A generated ticket that claimed a
// human had assessed the impact would be worse than one that admits it is an
// automatic transcription of an alarm.
func WorkFor(rule AlarmRule, a Alarm) AlarmWork {
	return AlarmWork{
		System: a.System, Priority: rule.Priority,
		ClassCode: rule.ClassCode, OwnerTeam: rule.OwnerTeam,
		AssetID: a.AssetID,
		Fault: fmt.Sprintf("%s alarm on %s: %s",
			a.Severity, a.PointRef, a.Message),
		Impact: fmt.Sprintf(
			"raised automatically from %s gateway %s; impact not yet assessed",
			a.System, a.GatewayID),
	}
}

// UnansweredAlarms lists alarms nobody has acknowledged, loudest first
// (SRS-FAC-005, SRS-FAC-009).
//
// Cleared alarms are included. An alarm that came and went without anybody
// acknowledging it is the one worth looking at: it means the plant told the
// hospital something and the hospital was not listening.
func UnansweredAlarms(alarms []Alarm) []Alarm {
	out := make([]Alarm, 0, len(alarms))
	for _, alarm := range alarms {
		if !alarm.Acknowledged() && alarm.Severity != SeverityInfo {
			out = append(out, alarm)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Severity != out[j].Severity {
			return out[i].Severity.rank() < out[j].Severity.rank()
		}
		return out[i].RaisedAt.Before(out[j].RaisedAt)
	})
	return out
}
