package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Requests and trips (SRS-AMB-001, SRS-AMB-002, SRS-AMB-003, SRS-AMB-007).

// Priority is how fast the call has to be answered (SRS-AMB-001).
type Priority string

const (
	// PriorityImmediate is life-threatening: a blue-light response.
	PriorityImmediate Priority = "immediate"
	// PriorityUrgent is serious but not immediately life-threatening.
	PriorityUrgent Priority = "urgent"
	// PriorityRoutine is a booked journey.
	PriorityRoutine Priority = "routine"
)

var knownPriority = map[Priority]bool{
	PriorityImmediate: true, PriorityUrgent: true, PriorityRoutine: true,
}

// Emergency reports the priorities that need a responding vehicle
// (SRS-AMB-001, SRS-AMB-002).
func (p Priority) Emergency() bool {
	return p == PriorityImmediate || p == PriorityUrgent
}

// rank orders the dispatch queue. Lower is sooner.
func (p Priority) rank() int {
	switch p {
	case PriorityImmediate:
		return 0
	case PriorityUrgent:
		return 1
	default:
		return 2
	}
}

// RequestKind is why the ambulance is wanted (SRS-AMB-001, SRS-AMB-007).
type RequestKind string

const (
	// RequestEmergency is a call to a scene.
	RequestEmergency RequestKind = "emergency"
	// RequestInterfacility is a transfer between hospitals, which carries a
	// sending and a receiving handover (SRS-AMB-007).
	RequestInterfacility RequestKind = "interfacility"
	// RequestDischarge is taking a patient home.
	RequestDischarge RequestKind = "discharge"
)

var knownRequestKind = map[RequestKind]bool{
	RequestEmergency: true, RequestInterfacility: true,
	RequestDischarge: true,
}

// RequestState is where an ambulance request stands (SRS-AMB-001).
type RequestState string

const (
	// RequestQueued is in the dispatch queue and not yet assigned.
	RequestQueued RequestState = "queued"
	// RequestAssigned has a vehicle and a crew.
	RequestAssigned RequestState = "assigned"
	// RequestCompleted is a trip that finished.
	RequestCompleted RequestState = "completed"
	// RequestCancelled is a call stood down. Kept and reported, because
	// SRS-AMB-008 asks for the cancellation rate and a deleted request is a
	// cancellation that never happened.
	RequestCancelled RequestState = "cancelled"
)

// Request is somebody asking for an ambulance (SRS-AMB-001).
type Request struct {
	ID       string
	TenantID string

	Kind     RequestKind
	Priority Priority

	// PatientID is empty for a call to a scene where nobody is identified
	// yet. Empty is not an error: an ambulance goes to an address, not to a
	// medical record number.
	PatientID string
	// EncounterID is the emergency encounter the prehospital record
	// attaches to on arrival (SRS-AMB-004). Filled in when there is one.
	EncounterID string

	OriginName    string
	OriginAddress string
	// OriginFacilityID is set for a transfer out of a hospital
	// (SRS-AMB-007).
	OriginFacilityID string

	DestinationName       string
	DestinationAddress    string
	DestinationFacilityID string

	// ClinicalNeed is what the crew is going to. Free text, because the
	// person on the phone says what they say.
	ClinicalNeed string
	// RequiredCapabilities are what the vehicle has to carry. Matched
	// against the vehicle rather than left to the dispatcher's memory.
	RequiredCapabilities []string

	State RequestState
	// TripID is the trip that answered it.
	TripID string

	CancelReason string
	CancelledBy  string
	CancelledAt  time.Time

	// RequestedAt is the queue timestamp SRS-AMB-001's acceptance asks for,
	// and the clock every response-time figure is measured from.
	RequestedAt time.Time
	RequestedBy string
	Version     int64
}

// NewRequestInput raises an ambulance request.
type NewRequestInput struct {
	Kind                  RequestKind
	Priority              Priority
	PatientID             string
	EncounterID           string
	OriginName            string
	OriginAddress         string
	OriginFacilityID      string
	DestinationName       string
	DestinationAddress    string
	DestinationFacilityID string
	ClinicalNeed          string
	RequiredCapabilities  []string
}

// RaiseRequest puts an ambulance request into the dispatch queue
// (SRS-AMB-001, SRS-AMB-007).
func RaiseRequest(id, tenantID string, in NewRequestInput, by string,
	now time.Time) (Request, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Request{}, fmt.Errorf("%w: a request needs an id",
			ErrInvalidAmbulance)
	case !knownRequestKind[in.Kind]:
		return Request{}, fmt.Errorf("%w: unknown request kind %q",
			ErrInvalidAmbulance, in.Kind)
	case !knownPriority[in.Priority]:
		// A request whose priority nobody set would queue behind a booked
		// discharge.
		return Request{}, fmt.Errorf("%w: unknown priority %q",
			ErrInvalidAmbulance, in.Priority)
	case strings.TrimSpace(by) == "":
		return Request{}, fmt.Errorf("%w: a request names who raised it",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.OriginName) == "" &&
		strings.TrimSpace(in.OriginAddress) == "" &&
		strings.TrimSpace(in.OriginFacilityID) == "":
		// A crew cannot be sent to nowhere.
		return Request{}, fmt.Errorf("%w: a request says where to go",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.ClinicalNeed) == "":
		// SRS-AMB-001's acceptance names the clinical need, and the reason
		// is that it decides which vehicle goes.
		return Request{}, fmt.Errorf(
			"%w: a request says what the patient needs",
			ErrInvalidAmbulance)
	}

	if in.Kind == RequestInterfacility {
		if strings.TrimSpace(in.OriginFacilityID) == "" ||
			strings.TrimSpace(in.DestinationFacilityID) == "" {
			// SRS-AMB-007 is a transfer between two hospitals, and a
			// handover needs both ends of it named.
			return Request{}, fmt.Errorf(
				"%w: an interfacility transfer names the sending and the "+
					"receiving facility", ErrInvalidAmbulance)
		}
		if in.OriginFacilityID == in.DestinationFacilityID {
			return Request{}, fmt.Errorf(
				"%w: an interfacility transfer goes somewhere else",
				ErrInvalidAmbulance)
		}
	}

	return Request{
		ID: id, TenantID: tenantID,
		Kind: in.Kind, Priority: in.Priority,
		PatientID:          strings.TrimSpace(in.PatientID),
		EncounterID:        strings.TrimSpace(in.EncounterID),
		OriginName:         strings.TrimSpace(in.OriginName),
		OriginAddress:      strings.TrimSpace(in.OriginAddress),
		OriginFacilityID:   strings.TrimSpace(in.OriginFacilityID),
		DestinationName:    strings.TrimSpace(in.DestinationName),
		DestinationAddress: strings.TrimSpace(in.DestinationAddress),
		DestinationFacilityID: strings.TrimSpace(
			in.DestinationFacilityID),
		ClinicalNeed:         strings.TrimSpace(in.ClinicalNeed),
		RequiredCapabilities: normalise(in.RequiredCapabilities),
		State:                RequestQueued,
		RequestedAt:          now.UTC(), RequestedBy: by, Version: 1,
	}, nil
}

// Cancel stands a request down (SRS-AMB-001, SRS-AMB-008).
func (r *Request) Cancel(reason, by string, now time.Time) error {
	switch {
	case r.State == RequestCompleted:
		return fmt.Errorf("%w: this request has already been completed",
			ErrInvalidAmbulance)
	case r.State == RequestCancelled:
		return fmt.Errorf("%w: this request is already cancelled",
			ErrInvalidAmbulance)
	case strings.TrimSpace(reason) == "":
		// The cancellation rate SRS-AMB-008 asks for is only useful with
		// the reasons beside it: a service cancelling a fifth of its calls
		// because nobody was there is a different problem from one
		// cancelling them because no vehicle came.
		return fmt.Errorf("%w: say why the request is being cancelled",
			ErrInvalidAmbulance)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a cancellation names who made it",
			ErrInvalidAmbulance)
	}
	r.State = RequestCancelled
	r.CancelReason = strings.TrimSpace(reason)
	r.CancelledBy, r.CancelledAt = by, now.UTC()
	return nil
}

// Queue orders the requests waiting for a vehicle (SRS-AMB-001).
//
// Priority first, then oldest. A queue in arrival order sends the next
// vehicle to a booked discharge while a cardiac arrest waits, and a queue on
// priority alone leaves the oldest urgent call there all afternoon.
func Queue(requests []Request) []Request {
	var out []Request
	for _, request := range requests {
		if request.State == RequestQueued {
			out = append(out, request)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		left, right := out[a].Priority.rank(), out[b].Priority.rank()
		if left != right {
			return left < right
		}
		if !out[a].RequestedAt.Equal(out[b].RequestedAt) {
			return out[a].RequestedAt.Before(out[b].RequestedAt)
		}
		return out[a].ID < out[b].ID
	})
	return out
}

// Milestone is a point on a trip's timeline (SRS-AMB-003).
//
// The order here is the order they happen in, and the trip refuses one out of
// sequence. A timeline whose points can arrive in any order is one where
// "arrived at scene before dispatched" is a row somebody has to explain.
type Milestone string

const (
	MilestoneDispatched    Milestone = "dispatched"
	MilestoneMobile        Milestone = "mobile"
	MilestoneAtScene       Milestone = "at_scene"
	MilestoneWithPatient   Milestone = "with_patient"
	MilestoneLeftScene     Milestone = "left_scene"
	MilestoneAtDestination Milestone = "at_destination"
	MilestoneHandover      Milestone = "handover"
	MilestoneClear         Milestone = "clear"
)

// milestoneOrder is the sequence a trip runs through.
var milestoneOrder = []Milestone{
	MilestoneDispatched, MilestoneMobile, MilestoneAtScene,
	MilestoneWithPatient, MilestoneLeftScene, MilestoneAtDestination,
	MilestoneHandover, MilestoneClear,
}

func milestoneIndex(m Milestone) (int, bool) {
	for i, known := range milestoneOrder {
		if known == m {
			return i, true
		}
	}
	return 0, false
}

// MilestoneRecord is one point recorded, with who recorded it
// (SRS-AMB-003).
type MilestoneRecord struct {
	Milestone Milestone
	At        time.Time
	By        string
	// Note carries anything the timestamp cannot say.
	Note string
	// AmendsAt is the timestamp this record corrected, where it is a
	// correction. Zero for an original. A corrected timeline keeps what it
	// corrected, because "the arrival time was changed after the complaint"
	// is a question somebody asks.
	AmendsAt time.Time
	// AmendReason is why. Required for a correction.
	AmendReason string

	// AmendedAt is when the correction was made, which is a different
	// question from what the time was corrected to. "The arrival time was
	// changed three weeks after the complaint" is the answer somebody
	// needs, and it is not derivable from the corrected value.
	AmendedAt time.Time
}

// TripState is where a trip stands (SRS-AMB-003).
type TripState string

const (
	TripActive TripState = "active"
	// TripCompleted is the crew clear and back on the run.
	TripCompleted TripState = "completed"
	// TripAborted is a trip that stopped before it finished — stood down en
	// route, or the patient refused.
	TripAborted TripState = "aborted"
)

// Trip is a vehicle and crew answering a request (SRS-AMB-003).
type Trip struct {
	ID       string
	TenantID string

	RequestID  string
	VehicleID  string
	ShiftID    string
	FacilityID string

	// CrewSubjects are who was on it, copied from the shift at dispatch.
	// A shift edited afterwards must not change who a prehospital record
	// says was there.
	CrewSubjects []string

	// AssignedDespite records an assignment made against an unavailable or
	// unready vehicle, with who made it and why (SRS-AMB-002). Empty for
	// the ordinary case.
	OverrideBy     string
	OverrideReason string

	State TripState
	// Milestones are append-only and in order (SRS-AMB-003).
	Milestones []MilestoneRecord

	AbortReason string

	StartedAt time.Time
	StartedBy string
	EndedAt   time.Time
	Version   int64
}

// Dispatch sends a vehicle to a request (SRS-AMB-002, SRS-AMB-003).
//
// The vehicle, the shift and the request are passed in and checked rather
// than named. SRS-AMB-002's acceptance is that an unavailable vehicle or crew
// cannot be assigned without an override, and the only way to mean that is
// for the thing doing the assigning to have looked.
func Dispatch(id, tenantID string, request Request, vehicle Vehicle,
	shift Shift, overrideBy, overrideReason, by string, now time.Time) (Trip,
	error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Trip{}, fmt.Errorf("%w: a trip needs an id",
			ErrInvalidAmbulance)
	case request.State != RequestQueued:
		return Trip{}, fmt.Errorf("%w: this request is %s",
			ErrInvalidAmbulance, request.State)
	case strings.TrimSpace(by) == "":
		return Trip{}, fmt.Errorf("%w: a dispatch names who made it",
			ErrInvalidAmbulance)
	case shift.VehicleID != vehicle.ID:
		return Trip{}, fmt.Errorf(
			"%w: that crew is rostered to vehicle %s, not %s",
			ErrInvalidAmbulance, shift.VehicleID, vehicle.ID)
	case request.Priority.Emergency() && !vehicle.Kind.Responds():
		// A patient transport van sent to a cardiac arrest is a van with no
		// defibrillator in it, and no override makes one appear.
		return Trip{}, fmt.Errorf(
			"%w: a %s vehicle does not answer a %s call",
			ErrInvalidAmbulance, vehicle.Kind, request.Priority)
	}

	// Everything below here is overridable, and the override is one thing:
	// a named person and a reason.
	var blockers []string
	if !vehicle.State.Assignable() {
		blockers = append(blockers, "the vehicle is "+string(vehicle.State))
	}
	if !vehicle.Ready(now) {
		blockers = append(blockers, "the readiness check has lapsed")
	}
	if !shift.OnDuty(now) {
		blockers = append(blockers, "the crew is not on duty")
	}
	if missing := missingCapabilities(request, vehicle); len(missing) > 0 {
		blockers = append(blockers,
			"the vehicle does not carry "+strings.Join(missing, ", "))
	}

	if len(blockers) > 0 {
		if strings.TrimSpace(overrideBy) == "" ||
			strings.TrimSpace(overrideReason) == "" {
			return Trip{}, fmt.Errorf("%w: %s; override by name and reason "+
				"to send it anyway", ErrInvalidAmbulance,
				strings.Join(blockers, "; "))
		}
	}

	crew := make([]string, 0, len(shift.Crew))
	for _, member := range shift.Crew {
		crew = append(crew, member.SubjectID)
	}

	return Trip{
		ID: id, TenantID: tenantID,
		RequestID: request.ID, VehicleID: vehicle.ID, ShiftID: shift.ID,
		FacilityID: tripFacility(request, vehicle), CrewSubjects: crew,
		OverrideBy:     strings.TrimSpace(overrideBy),
		OverrideReason: strings.TrimSpace(overrideReason),
		State:          TripActive,
		Milestones: []MilestoneRecord{{
			Milestone: MilestoneDispatched, At: now.UTC(), By: by,
		}},
		StartedAt: now.UTC(), StartedBy: by, Version: 1,
	}, nil
}

// tripFacility decides which service the trip belongs to.
//
// The vehicle's base first. Most emergency calls come from a street with no
// facility at either end, and a trip attributed to the request's origin would
// leave every emergency job out of the service's own report — which is the
// half of the fleet a response-time figure is about. Where the vehicle has no
// base, the request's own facilities stand in.
func tripFacility(request Request, vehicle Vehicle) string {
	for _, candidate := range []string{
		vehicle.FacilityID,
		request.OriginFacilityID,
		request.DestinationFacilityID,
	} {
		if strings.TrimSpace(candidate) != "" {
			return candidate
		}
	}
	return ""
}

func missingCapabilities(request Request, vehicle Vehicle) []string {
	has := map[string]bool{}
	for _, capability := range vehicle.Capabilities {
		has[strings.ToLower(capability)] = true
	}
	var missing []string
	for _, wanted := range request.RequiredCapabilities {
		if !has[strings.ToLower(wanted)] {
			missing = append(missing, wanted)
		}
	}
	return missing
}

// Overridden reports a trip sent against a blocker (SRS-AMB-002).
func (t Trip) Overridden() bool { return t.OverrideBy != "" }

// RecordMilestone appends a point to the timeline (SRS-AMB-003).
//
// Forward only, and each one once. A timeline that accepted "at scene" twice
// would have two arrival times and one response-time figure that is whichever
// the report reached first; one that accepted a milestone out of order would
// have a crew arriving before it was sent.
func (t *Trip) RecordMilestone(milestone Milestone, note, by string,
	now time.Time) error {

	index, known := milestoneIndex(milestone)
	switch {
	case !known:
		return fmt.Errorf("%w: unknown milestone %q",
			ErrInvalidAmbulance, milestone)
	case t.State != TripActive:
		return fmt.Errorf("%w: this trip is %s",
			ErrInvalidAmbulance, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a milestone names who recorded it",
			ErrInvalidAmbulance)
	}

	last := -1
	for _, record := range t.Milestones {
		if record.AmendsAt.IsZero() {
			existing, _ := milestoneIndex(record.Milestone)
			if existing == index {
				return fmt.Errorf("%w: %s has already been recorded at %s",
					ErrInvalidAmbulance, milestone,
					record.At.Format(time.RFC3339))
			}
			if existing > last {
				last = existing
			}
		}
	}
	if index < last {
		return fmt.Errorf(
			"%w: %s comes before %s, which has already been recorded",
			ErrInvalidAmbulance, milestone, milestoneOrder[last])
	}

	t.Milestones = append(t.Milestones, MilestoneRecord{
		Milestone: milestone, At: now.UTC(), By: by,
		Note: strings.TrimSpace(note),
	})
	if milestone == MilestoneClear {
		t.State = TripCompleted
		t.EndedAt = now.UTC()
	}
	return nil
}

// AmendMilestone corrects a recorded time (SRS-AMB-003).
//
// The original stays. "The arrival time was changed after the complaint" is a
// question somebody asks, and a timeline that answered it by having only one
// value would not be auditable at all.
func (t *Trip) AmendMilestone(milestone Milestone, at time.Time,
	reason, by string, now time.Time) error {

	if _, known := milestoneIndex(milestone); !known {
		return fmt.Errorf("%w: unknown milestone %q",
			ErrInvalidAmbulance, milestone)
	}
	switch {
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an amendment names who made it",
			ErrInvalidAmbulance)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the time is being corrected",
			ErrInvalidAmbulance)
	case at.IsZero():
		return fmt.Errorf("%w: an amendment says what the time should be",
			ErrInvalidAmbulance)
	}

	current, found := t.MilestoneAt(milestone)
	if !found {
		return fmt.Errorf("%w: %s has not been recorded",
			ErrInvalidAmbulance, milestone)
	}

	t.Milestones = append(t.Milestones, MilestoneRecord{
		Milestone: milestone, At: at.UTC(), By: by,
		AmendsAt: current, AmendReason: strings.TrimSpace(reason),
		AmendedAt: now.UTC(),
	})
	return nil
}

// MilestoneAt answers when a point happened, reading the latest amendment
// (SRS-AMB-003).
func (t Trip) MilestoneAt(milestone Milestone) (time.Time, bool) {
	var at time.Time
	found := false
	for _, record := range t.Milestones {
		if record.Milestone != milestone {
			continue
		}
		// A later record supersedes an earlier one, which for an original
		// is the record itself and for an amendment is the correction.
		at, found = record.At, true
	}
	return at, found
}

// Abort stops a trip that did not finish (SRS-AMB-003).
func (t *Trip) Abort(reason, by string, now time.Time) error {
	switch {
	case t.State != TripActive:
		return fmt.Errorf("%w: this trip is %s",
			ErrInvalidAmbulance, t.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the trip is being stopped",
			ErrInvalidAmbulance)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an abort names who made it",
			ErrInvalidAmbulance)
	}
	t.State = TripAborted
	t.AbortReason = strings.TrimSpace(reason)
	t.EndedAt = now.UTC()
	return nil
}

// TimelineGaps lists the milestones a finished trip never recorded
// (SRS-AMB-003).
//
// SRS-AMB-003's acceptance is that the timeline is complete. This is what
// makes "complete" checkable: a trip that reached the hospital with no "at
// scene" time has a response time nobody can compute, and the gap is reported
// rather than filled in with a guess.
func TimelineGaps(trip Trip) []Milestone {
	if trip.State == TripActive {
		return nil
	}
	recorded := map[Milestone]bool{}
	for _, record := range trip.Milestones {
		recorded[record.Milestone] = true
	}

	// An aborted trip is not expected to have reached the destination, so
	// only the points up to where it stopped are asked for.
	wanted := milestoneOrder
	if trip.State == TripAborted {
		wanted = []Milestone{MilestoneDispatched, MilestoneMobile}
	}

	var gaps []Milestone
	for _, milestone := range wanted {
		if !recorded[milestone] {
			gaps = append(gaps, milestone)
		}
	}
	return gaps
}
