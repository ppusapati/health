package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Patient movement (SRS-OT-008), delays (SRS-OT-014), the command board
// (SRS-OT-013) and the numbers derived from them (SRS-OT-015).

// Milestone is one point in a case's passage through theatre (SRS-OT-008).
//
// The eight SRS-OT-008 names. Every utilisation number below is derived from
// them, which is why nothing stores a duration: a stored turnover time is a
// number somebody can be asked to improve without a patient moving any sooner.
type Milestone string

const (
	MilestonePreOp            Milestone = "pre_op"
	MilestoneTheatreIn        Milestone = "theatre_in"
	MilestoneAnaesthesiaStart Milestone = "anaesthesia_start"
	MilestoneIncision         Milestone = "incision"
	MilestoneClosure          Milestone = "closure"
	MilestoneTheatreOut       Milestone = "theatre_out"
	MilestonePacuIn           Milestone = "pacu_in"
	MilestonePacuOut          Milestone = "pacu_out"
)

// milestoneOrder is the sequence a case passes through.
var milestoneOrder = []Milestone{
	MilestonePreOp, MilestoneTheatreIn, MilestoneAnaesthesiaStart,
	MilestoneIncision, MilestoneClosure, MilestoneTheatreOut,
	MilestonePacuIn, MilestonePacuOut,
}

func milestoneIndex(m Milestone) (int, bool) {
	for i, known := range milestoneOrder {
		if known == m {
			return i, true
		}
	}
	return 0, false
}

// MilestoneRecord is one milestone, timed.
type MilestoneRecord struct {
	ID       string
	TenantID string
	CaseID   string

	Milestone Milestone
	// OccurredAt is when the patient moved. RecordedAt is when somebody typed
	// it, kept separately for the reason the emergency timeline keeps them
	// apart: a theatre list written up at the end of the day is a
	// reconstruction, and the gap is the only thing that says so.
	OccurredAt time.Time
	RecordedAt time.Time
	RecordedBy string
	Note       string
}

// RecordMilestone times one milestone (SRS-OT-008).
func RecordMilestone(id, tenantID, caseID string, milestone Milestone,
	occurredAt time.Time, by, note string, now time.Time) (MilestoneRecord, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(caseID) == "":
		return MilestoneRecord{}, fmt.Errorf("%w: a milestone belongs to a case",
			ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return MilestoneRecord{}, fmt.Errorf("%w: a milestone names who recorded it",
			ErrInvalidCase)
	}
	if _, known := milestoneIndex(milestone); !known {
		return MilestoneRecord{}, fmt.Errorf("%w: unknown milestone %q",
			ErrInvalidCase, milestone)
	}

	occurred := occurredAt
	if occurred.IsZero() {
		occurred = now
	}
	return MilestoneRecord{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(caseID),
		Milestone: milestone, OccurredAt: occurred.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by), Note: strings.TrimSpace(note),
	}, nil
}

// Milestones is a case's movement record.
type Milestones []MilestoneRecord

// At returns when a milestone happened.
//
// Earliest wins, because a milestone recorded twice still happened once, and
// the first time is the one the interval is measured from.
func (m Milestones) At(milestone Milestone) (time.Time, bool) {
	var best time.Time
	found := false
	for _, record := range m {
		if record.Milestone != milestone {
			continue
		}
		if !found || record.OccurredAt.Before(best) {
			best, found = record.OccurredAt, true
		}
	}
	return best, found
}

// Reached reports the last milestone a case has passed, which is what the
// board shows as its stage (SRS-OT-013).
func (m Milestones) Reached() (Milestone, bool) {
	best := -1
	for _, record := range m {
		if index, known := milestoneIndex(record.Milestone); known && index > best {
			best = index
		}
	}
	if best < 0 {
		return "", false
	}
	return milestoneOrder[best], true
}

// OutOfSequence reports milestones recorded in an order the patient could not
// have moved in.
//
// Reported rather than refused. A closure timed before an incision is almost
// always a typing error, and refusing it would leave the real time unrecorded
// while somebody works out which field was wrong — but leaving it unremarked
// would put a negative operating time into the unit's reporting.
func (m Milestones) OutOfSequence() []string {
	var out []string
	var last time.Time
	var lastName Milestone
	for _, milestone := range milestoneOrder {
		at, ok := m.At(milestone)
		if !ok {
			continue
		}
		if !last.IsZero() && at.Before(last) {
			out = append(out, fmt.Sprintf("%s is timed before %s", milestone, lastName))
		}
		last, lastName = at, milestone
	}
	return out
}

// CaseIntervals are the durations SRS-OT-015 asks a theatre to report.
//
// Pointers, so an interval whose milestones have not both happened is absent
// rather than zero. A zero anaesthesia time would make a list look efficient
// while the patient was still in the anaesthetic room.
type CaseIntervals struct {
	// AnaesthesiaToIncision is induction and positioning.
	AnaesthesiaToIncision *time.Duration
	// IncisionToClosure is the operating time proper — what a surgeon means
	// by "how long does this take".
	IncisionToClosure *time.Duration
	// TheatreOccupancy is door to door, which is what the room was used for
	// and what utilisation is computed from.
	TheatreOccupancy *time.Duration
	// PacuStay is recovery.
	PacuStay *time.Duration
	// StartDelay is how late the case started against its booking. Negative
	// where it started early, because a list that consistently starts early is
	// as much a planning fact as one that starts late.
	StartDelay *time.Duration
}

// Intervals derives a case's durations from its milestones (SRS-OT-015).
func (m Milestones) Intervals(booked time.Time) CaseIntervals {
	out := CaseIntervals{}

	between := func(from, to Milestone) *time.Duration {
		start, okStart := m.At(from)
		end, okEnd := m.At(to)
		if !okStart || !okEnd {
			return nil
		}
		d := end.Sub(start)
		return &d
	}

	out.AnaesthesiaToIncision = between(MilestoneAnaesthesiaStart, MilestoneIncision)
	out.IncisionToClosure = between(MilestoneIncision, MilestoneClosure)
	out.TheatreOccupancy = between(MilestoneTheatreIn, MilestoneTheatreOut)
	out.PacuStay = between(MilestonePacuIn, MilestonePacuOut)

	if !booked.IsZero() {
		if actual, ok := m.At(MilestoneTheatreIn); ok {
			delay := actual.Sub(booked)
			out.StartDelay = &delay
		}
	}
	return out
}

// Delays (SRS-OT-014).

// DelayReason is a coded cause (SRS-OT-014).
//
// Coded, because the requirement's clause is "delay analytics are reportable
// without free-text-only classification". A theatre that records "late start"
// as a sentence produces a report nobody can act on, and the fixes for a late
// surgeon and a missing set of instruments are different departments' work.
type DelayReason string

const (
	DelayPatient      DelayReason = "patient"
	DelaySurgeon      DelayReason = "surgeon"
	DelayAnaesthesia  DelayReason = "anaesthesia"
	DelayNursing      DelayReason = "nursing"
	DelayEquipment    DelayReason = "equipment"
	DelayInstruments  DelayReason = "instruments"
	DelayCleaning     DelayReason = "cleaning"
	DelayBed          DelayReason = "bed"
	DelayPorters      DelayReason = "porters"
	DelayPreviousCase DelayReason = "previous_case"
	DelayEmergency    DelayReason = "emergency_insertion"
	DelayOther        DelayReason = "other"
)

var knownDelayReasons = map[DelayReason]bool{
	DelayPatient: true, DelaySurgeon: true, DelayAnaesthesia: true,
	DelayNursing: true, DelayEquipment: true, DelayInstruments: true,
	DelayCleaning: true, DelayBed: true, DelayPorters: true,
	DelayPreviousCase: true, DelayEmergency: true, DelayOther: true,
}

// Delay is one recorded delay (SRS-OT-014).
type Delay struct {
	ID       string
	TenantID string
	CaseID   string

	Reason DelayReason
	// Dependency is the department answerable — "cssd", "portering",
	// "radiology". Recorded because the requirement asks for the responsible
	// dependency, and because a theatre's delay report is read by the
	// departments it names.
	Dependency string
	Minutes    int
	Note       string

	RecordedAt time.Time
	RecordedBy string
}

// RecordDelay records a delay (SRS-OT-014).
func RecordDelay(id, tenantID, caseID string, reason DelayReason, dependency string,
	minutes int, note, by string, at time.Time) (Delay, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(caseID) == "":
		return Delay{}, fmt.Errorf("%w: a delay belongs to a case", ErrInvalidCase)
	case !knownDelayReasons[reason]:
		return Delay{}, fmt.Errorf(
			"%w: classify the delay; a free-text cause is a report nobody can act on",
			ErrInvalidCase)
	case reason == DelayOther && strings.TrimSpace(note) == "":
		return Delay{}, fmt.Errorf("%w: say what \"other\" was", ErrInvalidCase)
	case minutes <= 0:
		return Delay{}, fmt.Errorf("%w: a delay is a positive number of minutes",
			ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return Delay{}, fmt.Errorf("%w: a delay names who recorded it", ErrInvalidCase)
	}

	return Delay{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(caseID),
		Reason: reason, Dependency: strings.TrimSpace(dependency),
		Minutes: minutes, Note: strings.TrimSpace(note),
		RecordedAt: at.UTC(), RecordedBy: strings.TrimSpace(by),
	}, nil
}

// The command board (SRS-OT-013).

// RoomStage is what a room is doing.
type RoomStage string

const (
	StageEmpty     RoomStage = "empty"
	StageNextReady RoomStage = "next_case_ready"
	StageInUse     RoomStage = "in_use"
	// StageTurnover is between cases: the patient has left and the next has
	// not arrived. The interval a theatre manager watches.
	StageTurnover RoomStage = "turnover"
	StageClosed   RoomStage = "closed"
)

// BoardRow is one theatre on the command board (SRS-OT-013).
type BoardRow struct {
	RoomID   string
	RoomCode string
	Stage    RoomStage

	// Current is the case in the room, if any.
	CurrentCaseID    string
	CurrentProcedure string
	CurrentSurgeon   string
	// CurrentMilestone is the stage the case has reached, which is what
	// "status derives from milestones" means.
	CurrentMilestone Milestone
	// Elapsed is how long since the case entered the room.
	Elapsed time.Duration
	// OverRunning is set where the case has passed its booked end.
	OverRunning bool

	// Next is the case booked after it.
	NextCaseID    string
	NextProcedure string
	NextStart     time.Time
	// NextReady says whether the pre-operative checklist has cleared it, which
	// is the one thing a theatre manager most wants to know and most often
	// cannot see.
	NextReady bool
	// NextBlockers is what is stopping it, for the same reason.
	NextBlockers []string

	// TurnoverSoFar is how long the room has been empty between cases.
	TurnoverSoFar time.Duration
	// DelayMinutes is what has been recorded against the current case.
	DelayMinutes int
}

// BoardInput is what one row is assembled from.
type BoardInput struct {
	Room       Room
	Cases      []Case
	Milestones map[string]Milestones
	Delays     map[string]int
	// Blockers is the unmet pre-operative items per case.
	Blockers map[string][]Blocker
	// Closed marks a room under planned downtime now.
	Closed bool
}

// BuildBoard assembles the command board (SRS-OT-013).
//
// Derived from the milestones every time rather than stored as a status
// somebody sets: "status derives from milestones and manual authorized
// updates" is the requirement, and a stored stage is one that disagrees with
// the room the moment anybody forgets to update it.
func BuildBoard(inputs []BoardInput, now time.Time) []BoardRow {
	rows := make([]BoardRow, 0, len(inputs))

	for _, input := range inputs {
		row := BoardRow{
			RoomID: input.Room.ID, RoomCode: input.Room.Code, Stage: StageEmpty,
		}
		if input.Closed || !input.Room.Active {
			row.Stage = StageClosed
			rows = append(rows, row)
			continue
		}

		// Today's cases for this room, in booked order.
		day := make([]Case, 0, len(input.Cases))
		for _, item := range input.Cases {
			if item.RoomID == input.Room.ID && item.Status.Open() {
				day = append(day, item)
			}
		}
		sort.SliceStable(day, func(i, j int) bool {
			return day[i].ScheduledStart.Before(day[j].ScheduledStart)
		})

		var lastOut time.Time
		for _, item := range day {
			milestones := input.Milestones[item.ID]
			in, hasIn := milestones.At(MilestoneTheatreIn)
			out, hasOut := milestones.At(MilestoneTheatreOut)

			switch {
			case hasIn && !hasOut:
				row.Stage = StageInUse
				row.CurrentCaseID = item.ID
				row.CurrentProcedure = item.ProcedureDisplay
				row.CurrentSurgeon = item.SurgeonID
				row.CurrentMilestone, _ = milestones.Reached()
				row.Elapsed = now.Sub(in)
				row.OverRunning = !item.ScheduledEnd.IsZero() &&
					now.After(item.ScheduledEnd)
				row.DelayMinutes = input.Delays[item.ID]
			case hasOut && out.After(lastOut):
				lastOut = out
			case !hasIn:
				if row.NextCaseID == "" {
					row.NextCaseID = item.ID
					row.NextProcedure = item.ProcedureDisplay
					row.NextStart = item.ScheduledStart
					blockers := input.Blockers[item.ID]
					row.NextReady = item.Status == CaseReady && len(blockers) == 0
					for _, blocker := range blockers {
						row.NextBlockers = append(row.NextBlockers, blocker.Label)
					}
				}
			}
		}

		if row.Stage == StageEmpty && !lastOut.IsZero() {
			row.Stage = StageTurnover
			row.TurnoverSoFar = now.Sub(lastOut)
		}
		if row.Stage == StageEmpty && row.NextReady {
			row.Stage = StageNextReady
		}
		rows = append(rows, row)
	}

	sort.SliceStable(rows, func(i, j int) bool { return rows[i].RoomCode < rows[j].RoomCode })
	return rows
}

// Utilisation is a period's theatre numbers (SRS-OT-015).
type Utilisation struct {
	RoomID string
	From   time.Time
	To     time.Time

	// ScheduledMinutes is what was booked, OperatingMinutes what the rooms
	// were actually occupied by patients, and BlockMinutes the time allocated
	// in lists. Three numbers, because the ratio anybody quotes depends on
	// which pair they divided.
	ScheduledMinutes int
	OperatingMinutes int
	BlockMinutes     int

	Cases     int
	Completed int
	Cancelled int
	Postponed int
	// CancellationsByCause is the requirement's own clause: patient, clinical,
	// resource, administrative.
	CancellationsByCause map[CaseOutcome]int

	// OnTimeStarts counts cases that entered theatre within the grace period
	// of their booked time, and FirstCases how many of them were first on a
	// list — the number a theatre is actually judged on.
	OnTimeStarts     int
	FirstCases       int
	OnTimeFirstCases int

	TurnoverCount   int
	TurnoverMinutes int
	DelayMinutes    int
	DelaysByReason  map[DelayReason]int
}

// MeanTurnover is the average gap between cases, and whether there was one.
func (u Utilisation) MeanTurnover() (time.Duration, bool) {
	if u.TurnoverCount == 0 {
		return 0, false
	}
	return time.Duration(u.TurnoverMinutes/u.TurnoverCount) * time.Minute, true
}

// DefaultOnTimeGrace is how late a start may be and still count as on time.
// Fifteen minutes, which is the figure most published theatre measures use.
const DefaultOnTimeGrace = 15 * time.Minute

// ComputeUtilisation derives a room's numbers for a period (SRS-OT-015).
//
// Every number comes from the recorded timestamps, which is the requirement's
// "metrics reconcile to recorded timestamps". Nothing is stored and adjusted:
// a stored utilisation figure is one that can disagree with the cases it came
// from, and the disagreement is always discovered in a meeting.
func ComputeUtilisation(roomID string, from, to time.Time, cases []Case,
	milestones map[string]Milestones, delays map[string][]Delay, blocks []Block,
	grace time.Duration) Utilisation {

	if grace <= 0 {
		grace = DefaultOnTimeGrace
	}

	out := Utilisation{
		RoomID: roomID, From: from.UTC(), To: to.UTC(),
		CancellationsByCause: map[CaseOutcome]int{},
		DelaysByReason:       map[DelayReason]int{},
	}

	for _, block := range blocks {
		if block.RoomID != roomID || block.Kind != BlockList {
			continue
		}
		if !Overlaps(from, to, block.StartsAt, block.EndsAt) {
			continue
		}
		out.BlockMinutes += int(overlapOf(from, to, block.StartsAt, block.EndsAt).Minutes())
	}

	// Cases in the period, in order, so turnover is the gap between
	// consecutive ones.
	inPeriod := make([]Case, 0, len(cases))
	for _, item := range cases {
		if item.RoomID != roomID {
			continue
		}
		when := item.ScheduledStart
		if when.IsZero() {
			when = item.OutcomeAt
		}
		if when.Before(from) || !when.Before(to) {
			continue
		}
		inPeriod = append(inPeriod, item)
	}
	sort.SliceStable(inPeriod, func(i, j int) bool {
		return inPeriod[i].ScheduledStart.Before(inPeriod[j].ScheduledStart)
	})

	var previousOut time.Time
	for index, item := range inPeriod {
		out.Cases++
		if !item.ScheduledEnd.IsZero() && !item.ScheduledStart.IsZero() {
			out.ScheduledMinutes += int(item.ScheduledEnd.Sub(item.ScheduledStart).Minutes())
		}

		switch item.Status {
		case CaseCompleted:
			out.Completed++
		case CaseCancelled:
			out.Cancelled++
			out.CancellationsByCause[item.Outcome]++
		case CasePostponed:
			out.Postponed++
			out.CancellationsByCause[item.Outcome]++
		}

		record := milestones[item.ID]
		if in, ok := record.At(MilestoneTheatreIn); ok {
			if outAt, okOut := record.At(MilestoneTheatreOut); okOut {
				out.OperatingMinutes += int(outAt.Sub(in).Minutes())
				if !previousOut.IsZero() {
					gap := in.Sub(previousOut)
					if gap > 0 {
						out.TurnoverCount++
						out.TurnoverMinutes += int(gap.Minutes())
					}
				}
				previousOut = outAt
			}

			if !item.ScheduledStart.IsZero() {
				onTime := !in.After(item.ScheduledStart.Add(grace))
				if onTime {
					out.OnTimeStarts++
				}
				if index == 0 {
					out.FirstCases++
					if onTime {
						out.OnTimeFirstCases++
					}
				}
			}
		}

		for _, delay := range delays[item.ID] {
			out.DelayMinutes += delay.Minutes
			out.DelaysByReason[delay.Reason] += delay.Minutes
		}
	}

	return out
}

func overlapOf(aStart, aEnd, bStart, bEnd time.Time) time.Duration {
	start := aStart
	if bStart.After(start) {
		start = bStart
	}
	end := aEnd
	if bEnd.Before(end) {
		end = bEnd
	}
	if !end.After(start) {
		return 0
	}
	return end.Sub(start)
}
