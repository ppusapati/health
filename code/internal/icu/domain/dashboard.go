package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The unit dashboard (SRS-ICU-012) and advisory alarms (SRS-ICU-013).

// Provenance says where a number on the dashboard came from.
//
// SRS-ICU-012's clause is "dashboard data is traceable to source; stale feeds
// are visibly marked", and both halves are about the same failure: a dashboard
// is read at a glance by somebody deciding whether to walk to the bed, and a
// number with no provenance is one they cannot tell from a number that stopped
// updating an hour ago.
type Provenance struct {
	// ObservationID names the exact chart entry, so a clinician can open it.
	ObservationID string
	Source        SourceKind
	Validation    Validation
	DeviceID      string
	ObservedAt    time.Time
	// Stale marks a value from a feed that has gone quiet.
	Stale bool
}

// DashboardValue is one number on the dashboard, with its provenance.
type DashboardValue struct {
	Code    string
	Display string
	Value   float64
	Unit    string
	Provenance
}

// DashboardRow is one bed (SRS-ICU-012).
type DashboardRow struct {
	EpisodeID string
	PatientID string
	BedID     string
	UnitID    string

	// Display is what the board shows for the patient.
	Display string

	// Vitals are the configured summary values, most recent first by code.
	Vitals []DashboardValue
	// Support is what the patient is on now.
	Support []SupportKind
	// Devices is the lines and tubes in, and OverdueDevices how many of them
	// nobody has reviewed.
	Devices        int
	OverdueDevices int
	// DueAssessments is how many reassessments the bed is behind on.
	DueAssessments int
	// OpenGoals is what the round left outstanding.
	OpenGoals int
	// Balance is the running fluid balance for the configured window.
	Balance Balance
	// LatestScore is the most recent severity score, if one has been
	// calculated.
	LatestScore *Score

	// CareIntent and CPRStatus are the ceiling of treatment, shown because
	// SRS-ICU-015 says it must be "prominently visible to authorized care
	// team". Empty for a viewer without the permission — the row still
	// appears, because a clinician who may not read the ceiling still needs to
	// know the bed is occupied.
	CareIntent CareIntent
	CPRStatus  string
	// CeilingRestricted marks a row whose ceiling this viewer may not read, so
	// the absence is visible as a restriction rather than as "no ceiling
	// agreed" — the difference is the one that gets a patient resuscitated
	// against their wishes.
	CeilingRestricted bool

	// StaleFeeds is how many of this bed's values came from a quiet feed.
	StaleFeeds int
	// AdmittedAt and LengthOfStay place the patient in the unit's day.
	AdmittedAt       time.Time
	ReadyForTransfer bool
}

// DashboardInput is everything one row is assembled from.
type DashboardInput struct {
	Episode     Episode
	Chart       ObservationList
	VitalCodes  []string
	Support     []Support
	Devices     []InvasiveDevice
	Assessments []Assessment
	Goals       []Goal
	Balance     Balance
	Score       *Score
	Ceiling     *GoalsOfCare
	// MayReadCeiling is the caller's permission, passed in rather than
	// decided here: the domain redacts, the application authorises.
	MayReadCeiling bool
	// StaleAfter is how long a feed may be silent. Zero takes
	// DefaultStaleAfter.
	StaleAfter time.Duration
}

// BuildRow assembles one dashboard row (SRS-ICU-012).
func BuildRow(in DashboardInput, now time.Time) DashboardRow {
	staleAfter := in.StaleAfter
	if staleAfter <= 0 {
		staleAfter = DefaultStaleAfter
	}

	row := DashboardRow{
		EpisodeID: in.Episode.ID, PatientID: in.Episode.PatientID,
		BedID: in.Episode.BedID, UnitID: in.Episode.UnitID,
		Display:          "patient " + in.Episode.PatientID,
		Balance:          in.Balance,
		LatestScore:      in.Score,
		AdmittedAt:       in.Episode.AdmittedAt,
		ReadyForTransfer: in.Episode.Status == EpisodeReadyForTransfer,
	}

	chartable := in.Chart.Chartable()
	for _, code := range in.VitalCodes {
		observation, ok := chartable.Latest(code)
		if !ok {
			continue
		}
		stale := observation.Device.Stale(now, staleAfter)
		if stale {
			row.StaleFeeds++
		}
		row.Vitals = append(row.Vitals, DashboardValue{
			Code: observation.Code, Display: observation.Display,
			Value: observation.Value, Unit: observation.Unit,
			Provenance: Provenance{
				ObservationID: observation.ID,
				Source:        observation.Source,
				Validation:    observation.Validation,
				DeviceID:      observation.Device.DeviceID,
				ObservedAt:    observation.ObservedAt,
				Stale:         stale,
			},
		})
	}
	sort.SliceStable(row.Vitals, func(i, j int) bool {
		return row.Vitals[i].Code < row.Vitals[j].Code
	})

	for _, support := range in.Support {
		if support.Active() {
			row.Support = append(row.Support, support.Kind)
		}
	}
	sort.SliceStable(row.Support, func(i, j int) bool {
		return row.Support[i] < row.Support[j]
	})

	for _, device := range in.Devices {
		if !device.In() {
			continue
		}
		row.Devices++
		if device.ReviewOverdue(now) {
			row.OverdueDevices++
		}
	}

	row.DueAssessments = len(DueAssessments(in.Assessments, now))
	row.OpenGoals = len(OpenGoals(in.Goals))

	if in.Ceiling != nil {
		if in.MayReadCeiling {
			row.CareIntent, row.CPRStatus = in.Ceiling.Intent, in.Ceiling.CPRStatus
		} else {
			row.CeilingRestricted = true
		}
	}
	return row
}

// Alarms (SRS-ICU-013).
//
// The requirement is written as a prohibition, and it is the most important
// sentence in the family: "software alarm is advisory/operational and cannot
// suppress device-native safety behavior". A bedside monitor's alarm is a
// safety function of a regulated device. This software may notice things and
// tell people; it may not reach into that.
//
// Expressed in the type system rather than in a comment: there is no
// Acknowledge that silences anything at the bedside, no Suppress, and no
// concept of an alarm limit this system sets. An Alarm here is a worklist
// entry.

// AlarmSeverity is how loudly the worklist should say it.
type AlarmSeverity string

const (
	AlarmInformation AlarmSeverity = "information"
	AlarmWarning     AlarmSeverity = "warning"
	AlarmUrgent      AlarmSeverity = "urgent"
)

// Alarm is an advisory worklist entry (SRS-ICU-013).
//
// Note what it does not have: any field that would change what a bedside
// device does. An alarm is raised by this software, read by a human, and
// closed by a human; the monitor at the bedside neither knows nor cares.
type Alarm struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Kind is what noticed — "device_review_overdue", "assessment_overdue",
	// "feed_stale". Operational conditions, which is what this system is
	// entitled to have an opinion about.
	Kind     string
	Severity AlarmSeverity
	Summary  string

	RaisedAt time.Time
	// AcknowledgedBy and AcknowledgedAt close the worklist entry. They close
	// nothing at the bedside.
	AcknowledgedBy string
	AcknowledgedAt time.Time
}

// RaiseAlarm creates an advisory worklist entry.
func RaiseAlarm(id, tenantID, episodeID, kind string, severity AlarmSeverity,
	summary string, at time.Time) (Alarm, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(episodeID) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm belongs to an episode", ErrInvalidEpisode)
	case strings.TrimSpace(kind) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm names what noticed", ErrInvalidEpisode)
	case strings.TrimSpace(summary) == "":
		return Alarm{}, fmt.Errorf("%w: an alarm says what to do about it",
			ErrInvalidEpisode)
	}
	if severity == "" {
		severity = AlarmWarning
	}
	return Alarm{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(episodeID),
		Kind: strings.TrimSpace(kind), Severity: severity,
		Summary: strings.TrimSpace(summary), RaisedAt: at.UTC(),
	}, nil
}

// Acknowledge closes the worklist entry.
//
// Named acknowledge rather than silence, because silencing is what it must not
// be mistaken for: nothing here reaches the bedside.
func (a *Alarm) Acknowledge(by string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: acknowledging an alarm names who did", ErrInvalidEpisode)
	}
	if !a.AcknowledgedAt.IsZero() {
		return nil
	}
	a.AcknowledgedBy, a.AcknowledgedAt = strings.TrimSpace(by), at.UTC()
	return nil
}

// Open reports an alarm nobody has answered.
func (a Alarm) Open() bool { return a.AcknowledgedAt.IsZero() }

// OperationalAlarms derives the advisory conditions one bed is in.
//
// Derived rather than stored, so a condition that has resolved stops being an
// alarm without anybody clearing it. A stored alarm for a device that was
// removed is the kind of noise that teaches a unit to ignore the list.
func OperationalAlarms(episode Episode, devices []InvasiveDevice,
	assessments []Assessment, chart ObservationList, staleAfter time.Duration,
	now time.Time) []Alarm {

	if staleAfter <= 0 {
		staleAfter = DefaultStaleAfter
	}
	var out []Alarm

	for _, device := range devices {
		if !device.ReviewOverdue(now) {
			continue
		}
		out = append(out, Alarm{
			EpisodeID: episode.ID, Kind: "device_review_overdue",
			Severity: AlarmWarning,
			Summary: fmt.Sprintf("%s at %s has not been reviewed. Ask whether it can come out.",
				device.Kind, device.Site),
			RaisedAt: now.UTC(),
		})
	}

	for _, assessment := range DueAssessments(assessments, now) {
		severity := AlarmWarning
		if assessment.Kind == AssessmentRestraint {
			// A restrained patient is the one the unit is most answerable for.
			severity = AlarmUrgent
		}
		out = append(out, Alarm{
			EpisodeID: episode.ID, Kind: "assessment_overdue", Severity: severity,
			Summary:  fmt.Sprintf("%s reassessment is overdue.", assessment.Kind),
			RaisedAt: now.UTC(),
		})
	}

	seen := map[string]bool{}
	for _, observation := range chart {
		device := observation.Device.DeviceID
		if device == "" || seen[device] {
			continue
		}
		if !observation.Device.Stale(now, staleAfter) {
			continue
		}
		seen[device] = true
		out = append(out, Alarm{
			EpisodeID: episode.ID, Kind: "feed_stale", Severity: AlarmInformation,
			Summary: fmt.Sprintf(
				"Nothing has arrived from %s. The values shown for it are not current.",
				device),
			RaisedAt: now.UTC(),
		})
	}

	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Kind != out[j].Kind {
			return out[i].Kind < out[j].Kind
		}
		return out[i].Summary < out[j].Summary
	})
	return out
}
