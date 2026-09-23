// Package transport translates between the ambulance contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised vehicle kind
// stays empty and the domain refuses it rather than defaulting to ALS, which
// would let a van answer a cardiac arrest; an unrecognised priority stays
// empty rather than becoming routine, which would put a cardiac arrest behind
// a booked discharge; an unrecognised crew role stays empty rather than
// becoming paramedic, which would let a driver record a drug.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	ambulancev1 "github.com/ppusapati/health/code/gen/go/healthcare/ambulance/v1"
	"github.com/ppusapati/health/code/internal/ambulance/application"
	"github.com/ppusapati/health/code/internal/ambulance/domain"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on
		// the wire, and a vehicle whose check expired in 1970 is one every
		// screen shows as unready for the wrong reason.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var vehicleKindFromWire = map[ambulancev1.VehicleKind]domain.VehicleKind{
	ambulancev1.VehicleKind_VEHICLE_KIND_ALS:       domain.VehicleALS,
	ambulancev1.VehicleKind_VEHICLE_KIND_BLS:       domain.VehicleBLS,
	ambulancev1.VehicleKind_VEHICLE_KIND_TRANSPORT: domain.VehicleTransport,
	ambulancev1.VehicleKind_VEHICLE_KIND_NEONATAL:  domain.VehicleNeonatal,
}

var vehicleStateFromWire = map[ambulancev1.VehicleState]domain.VehicleState{
	ambulancev1.VehicleState_VEHICLE_STATE_OUT_OF_SERVICE: domain.VehicleOutOfService,
	ambulancev1.VehicleState_VEHICLE_STATE_AVAILABLE:      domain.VehicleAvailable,
	ambulancev1.VehicleState_VEHICLE_STATE_ON_TRIP:        domain.VehicleOnTrip,
	ambulancev1.VehicleState_VEHICLE_STATE_RETIRED:        domain.VehicleRetired,
}

var crewRoleFromWire = map[ambulancev1.CrewRole]domain.CrewRole{
	ambulancev1.CrewRole_CREW_ROLE_DRIVER:    domain.CrewDriver,
	ambulancev1.CrewRole_CREW_ROLE_EMT:       domain.CrewEMT,
	ambulancev1.CrewRole_CREW_ROLE_PARAMEDIC: domain.CrewParamedic,
	ambulancev1.CrewRole_CREW_ROLE_NURSE:     domain.CrewNurse,
	ambulancev1.CrewRole_CREW_ROLE_DOCTOR:    domain.CrewDoctor,
}

var shiftStateFromWire = map[ambulancev1.ShiftState]domain.ShiftState{
	ambulancev1.ShiftState_SHIFT_STATE_PLANNED: domain.ShiftPlanned,
	ambulancev1.ShiftState_SHIFT_STATE_ON_DUTY: domain.ShiftOnDuty,
	ambulancev1.ShiftState_SHIFT_STATE_ENDED:   domain.ShiftEnded,
}

var checkStateFromWire = map[ambulancev1.CheckState]domain.CheckState{
	ambulancev1.CheckState_CHECK_STATE_PASSED:     domain.CheckPassed,
	ambulancev1.CheckState_CHECK_STATE_FAILED:     domain.CheckFailed,
	ambulancev1.CheckState_CHECK_STATE_OVERRIDDEN: domain.CheckOverridden,
}

var priorityFromWire = map[ambulancev1.Priority]domain.Priority{
	ambulancev1.Priority_PRIORITY_IMMEDIATE: domain.PriorityImmediate,
	ambulancev1.Priority_PRIORITY_URGENT:    domain.PriorityUrgent,
	ambulancev1.Priority_PRIORITY_ROUTINE:   domain.PriorityRoutine,
}

var requestKindFromWire = map[ambulancev1.RequestKind]domain.RequestKind{
	ambulancev1.RequestKind_REQUEST_KIND_EMERGENCY:     domain.RequestEmergency,
	ambulancev1.RequestKind_REQUEST_KIND_INTERFACILITY: domain.RequestInterfacility,
	ambulancev1.RequestKind_REQUEST_KIND_DISCHARGE:     domain.RequestDischarge,
}

var requestStateFromWire = map[ambulancev1.RequestState]domain.RequestState{
	ambulancev1.RequestState_REQUEST_STATE_QUEUED:    domain.RequestQueued,
	ambulancev1.RequestState_REQUEST_STATE_ASSIGNED:  domain.RequestAssigned,
	ambulancev1.RequestState_REQUEST_STATE_COMPLETED: domain.RequestCompleted,
	ambulancev1.RequestState_REQUEST_STATE_CANCELLED: domain.RequestCancelled,
}

var milestoneFromWire = map[ambulancev1.Milestone]domain.Milestone{
	ambulancev1.Milestone_MILESTONE_DISPATCHED:     domain.MilestoneDispatched,
	ambulancev1.Milestone_MILESTONE_MOBILE:         domain.MilestoneMobile,
	ambulancev1.Milestone_MILESTONE_AT_SCENE:       domain.MilestoneAtScene,
	ambulancev1.Milestone_MILESTONE_WITH_PATIENT:   domain.MilestoneWithPatient,
	ambulancev1.Milestone_MILESTONE_LEFT_SCENE:     domain.MilestoneLeftScene,
	ambulancev1.Milestone_MILESTONE_AT_DESTINATION: domain.MilestoneAtDestination,
	ambulancev1.Milestone_MILESTONE_HANDOVER:       domain.MilestoneHandover,
	ambulancev1.Milestone_MILESTONE_CLEAR:          domain.MilestoneClear,
}

var tripStateFromWire = map[ambulancev1.TripState]domain.TripState{
	ambulancev1.TripState_TRIP_STATE_ACTIVE:    domain.TripActive,
	ambulancev1.TripState_TRIP_STATE_COMPLETED: domain.TripCompleted,
	ambulancev1.TripState_TRIP_STATE_ABORTED:   domain.TripAborted,
}

var entryKindFromWire = map[ambulancev1.EntryKind]domain.EntryKind{
	ambulancev1.EntryKind_ENTRY_KIND_OBSERVATION:  domain.EntryObservation,
	ambulancev1.EntryKind_ENTRY_KIND_INTERVENTION: domain.EntryIntervention,
	ambulancev1.EntryKind_ENTRY_KIND_MEDICATION:   domain.EntryMedication,
	ambulancev1.EntryKind_ENTRY_KIND_NOTE:         domain.EntryNote,
}

var handoverStateFromWire = map[ambulancev1.HandoverState]domain.HandoverState{
	ambulancev1.HandoverState_HANDOVER_STATE_DRAFT:    domain.HandoverDraft,
	ambulancev1.HandoverState_HANDOVER_STATE_GIVEN:    domain.HandoverGiven,
	ambulancev1.HandoverState_HANDOVER_STATE_ACCEPTED: domain.HandoverAccepted,
}

var (
	vehicleKindToWire   = map[domain.VehicleKind]ambulancev1.VehicleKind{}
	vehicleStateToWire  = map[domain.VehicleState]ambulancev1.VehicleState{}
	crewRoleToWire      = map[domain.CrewRole]ambulancev1.CrewRole{}
	shiftStateToWire    = map[domain.ShiftState]ambulancev1.ShiftState{}
	checkStateToWire    = map[domain.CheckState]ambulancev1.CheckState{}
	priorityToWire      = map[domain.Priority]ambulancev1.Priority{}
	requestKindToWire   = map[domain.RequestKind]ambulancev1.RequestKind{}
	requestStateToWire  = map[domain.RequestState]ambulancev1.RequestState{}
	milestoneToWire     = map[domain.Milestone]ambulancev1.Milestone{}
	tripStateToWire     = map[domain.TripState]ambulancev1.TripState{}
	entryKindToWire     = map[domain.EntryKind]ambulancev1.EntryKind{}
	handoverStateToWire = map[domain.HandoverState]ambulancev1.HandoverState{}
)

func init() {
	for wire, value := range vehicleKindFromWire {
		vehicleKindToWire[value] = wire
	}
	for wire, value := range vehicleStateFromWire {
		vehicleStateToWire[value] = wire
	}
	for wire, value := range crewRoleFromWire {
		crewRoleToWire[value] = wire
	}
	for wire, value := range shiftStateFromWire {
		shiftStateToWire[value] = wire
	}
	for wire, value := range checkStateFromWire {
		checkStateToWire[value] = wire
	}
	for wire, value := range priorityFromWire {
		priorityToWire[value] = wire
	}
	for wire, value := range requestKindFromWire {
		requestKindToWire[value] = wire
	}
	for wire, value := range requestStateFromWire {
		requestStateToWire[value] = wire
	}
	for wire, value := range milestoneFromWire {
		milestoneToWire[value] = wire
	}
	for wire, value := range tripStateFromWire {
		tripStateToWire[value] = wire
	}
	for wire, value := range entryKindFromWire {
		entryKindToWire[value] = wire
	}
	for wire, value := range handoverStateFromWire {
		handoverStateToWire[value] = wire
	}
}

func vehicleToWire(v domain.Vehicle) *ambulancev1.Vehicle {
	return &ambulancev1.Vehicle{
		VehicleId: v.ID, Registration: v.Registration,
		CallSign: v.CallSign, Kind: vehicleKindToWire[v.Kind],
		FacilityId: v.FacilityID, BaseId: v.BaseID,
		Capabilities:       v.Capabilities,
		State:              vehicleStateToWire[v.State],
		ReadyUntil:         stamp(v.ReadyUntil),
		OutOfServiceReason: v.OutOfServiceReason,
		CreatedAt:          stamp(v.CreatedAt), CreatedBy: v.CreatedBy,
		Version: v.Version,
	}
}

func crewToWire(crew []domain.CrewMember) []*ambulancev1.CrewMember {
	out := make([]*ambulancev1.CrewMember, 0, len(crew))
	for _, member := range crew {
		out = append(out, &ambulancev1.CrewMember{
			SubjectId: member.SubjectID, DisplayName: member.Name,
			Role:               crewRoleToWire[member.Role],
			RegistrationNumber: member.RegistrationNumber,
		})
	}
	return out
}

func crewFromWire(crew []*ambulancev1.CrewMember) []application.CrewMemberInput {
	out := make([]application.CrewMemberInput, 0, len(crew))
	for _, member := range crew {
		out = append(out, application.CrewMemberInput{
			SubjectID:          member.GetSubjectId(),
			Name:               member.GetDisplayName(),
			Role:               string(crewRoleFromWire[member.GetRole()]),
			RegistrationNumber: member.GetRegistrationNumber(),
		})
	}
	return out
}

func shiftToWire(s domain.Shift) *ambulancev1.Shift {
	return &ambulancev1.Shift{
		ShiftId: s.ID, VehicleId: s.VehicleID, FacilityId: s.FacilityID,
		Crew: crewToWire(s.Crew), State: shiftStateToWire[s.State],
		StartsAt: stamp(s.StartsAt), EndsAt: stamp(s.EndsAt),
		StartedAt: stamp(s.StartedAt), EndedAt: stamp(s.EndedAt),
		Version: s.Version,
	}
}

func checkToWire(c domain.ReadinessCheck) *ambulancev1.ReadinessCheck {
	items := make([]*ambulancev1.ChecklistItem, 0, len(c.Items))
	for _, item := range c.Items {
		items = append(items, &ambulancev1.ChecklistItem{
			Code: item.Code, Label: item.Label, Critical: item.Critical,
		})
	}
	outcomes := make([]*ambulancev1.ItemOutcome, 0, len(c.Outcomes))
	for _, outcome := range c.Outcomes {
		outcomes = append(outcomes, &ambulancev1.ItemOutcome{
			Code: outcome.Code, Present: outcome.Present,
			Note: outcome.Note,
		})
	}
	return &ambulancev1.ReadinessCheck{
		CheckId: c.ID, VehicleId: c.VehicleID, ShiftId: c.ShiftID,
		FacilityId: c.FacilityID, Items: items, Outcomes: outcomes,
		OxygenBar:        int32(c.OxygenBar),
		OxygenMinimumBar: int32(c.OxygenMinimumBar),
		State:            checkStateToWire[c.State], Missing: c.Missing,
		OverrideBy: c.OverrideBy, OverrideReason: c.OverrideReason,
		OverrideAt: stamp(c.OverrideAt),
		ValidUntil: stamp(c.ValidUntil), CheckedAt: stamp(c.CheckedAt),
		CheckedBy: c.CheckedBy, Version: c.Version,
	}
}

func requestToWire(r domain.Request) *ambulancev1.Request {
	return &ambulancev1.Request{
		RequestId: r.ID, Kind: requestKindToWire[r.Kind],
		Priority:  priorityToWire[r.Priority],
		PatientId: r.PatientID, EncounterId: r.EncounterID,
		OriginName: r.OriginName, OriginAddress: r.OriginAddress,
		OriginFacilityId:      r.OriginFacilityID,
		DestinationName:       r.DestinationName,
		DestinationAddress:    r.DestinationAddress,
		DestinationFacilityId: r.DestinationFacilityID,
		ClinicalNeed:          r.ClinicalNeed,
		RequiredCapabilities:  r.RequiredCapabilities,
		State:                 requestStateToWire[r.State],
		TripId:                r.TripID,
		CancelReason:          r.CancelReason,
		CancelledBy:           r.CancelledBy,
		CancelledAt:           stamp(r.CancelledAt),
		RequestedAt:           stamp(r.RequestedAt),
		RequestedBy:           r.RequestedBy, Version: r.Version,
	}
}

func tripToWire(t domain.Trip) *ambulancev1.Trip {
	milestones := make([]*ambulancev1.MilestoneRecord, 0, len(t.Milestones))
	for _, record := range t.Milestones {
		milestones = append(milestones, &ambulancev1.MilestoneRecord{
			Milestone:  milestoneToWire[record.Milestone],
			OccurredAt: stamp(record.At), RecordedBy: record.By,
			Note: record.Note, AmendsAt: stamp(record.AmendsAt),
			AmendReason: record.AmendReason,
			AmendedAt:   stamp(record.AmendedAt),
		})
	}
	return &ambulancev1.Trip{
		TripId: t.ID, RequestId: t.RequestID, VehicleId: t.VehicleID,
		ShiftId: t.ShiftID, FacilityId: t.FacilityID,
		CrewSubjects: t.CrewSubjects, OverrideBy: t.OverrideBy,
		OverrideReason: t.OverrideReason,
		State:          tripStateToWire[t.State],
		Milestones:     milestones, AbortReason: t.AbortReason,
		StartedAt: stamp(t.StartedAt), StartedBy: t.StartedBy,
		EndedAt: stamp(t.EndedAt), Version: t.Version,
	}
}

func recordToWire(r domain.PrehospitalRecord) *ambulancev1.PrehospitalRecord {
	entries := make([]*ambulancev1.Entry, 0, len(r.Entries))
	for _, entry := range r.Entries {
		entries = append(entries, &ambulancev1.Entry{
			EntryId: entry.ID, Kind: entryKindToWire[entry.Kind],
			Code: entry.Code, Label: entry.Label,
			Value: entry.Value, Unit: entry.Unit,
			DoseAmount: int32(entry.DoseAmount),
			DoseUnit:   entry.DoseUnit, Route: entry.Route,
			Narrative: entry.Narrative, RecordedBy: entry.RecordedBy,
			RecordedRole: crewRoleToWire[entry.RecordedRole],
			RecordedAt:   stamp(entry.RecordedAt),
			EnteredAt:    stamp(entry.EnteredAt),
		})
	}
	return &ambulancev1.PrehospitalRecord{
		RecordId: r.ID, TripId: r.TripID, RequestId: r.RequestID,
		PatientId: r.PatientID, EncounterId: r.EncounterID,
		FacilityId:          r.FacilityID,
		PresentingComplaint: r.PresentingComplaint,
		Impression:          r.Impression, Entries: entries,
		State:          handoverStateToWire[r.State],
		SendingSummary: r.SendingSummary, GivenBy: r.GivenBy,
		GivenRole: crewRoleToWire[r.GivenRole],
		GivenAt:   stamp(r.GivenAt), AcceptedBy: r.AcceptedBy,
		AcceptedAt: stamp(r.AcceptedAt), AcceptedNote: r.AcceptedNote,
		DocumentRefs: r.DocumentRefs, Version: r.Version,
	}
}

func pingToWire(p domain.Ping) *ambulancev1.Ping {
	return &ambulancev1.Ping{
		PingId: p.ID, VehicleId: p.VehicleID, TripId: p.TripID,
		LatitudeMicro:  int32(p.LatitudeMicro),
		LongitudeMicro: int32(p.LongitudeMicro),
		SpeedKph:       int32(p.SpeedKph),
		HeadingDegrees: int32(p.HeadingDegrees),
		AccuracyMetres: int32(p.AccuracyMetres),
		Source:         p.Source, OccurredAt: stamp(p.At),
		RetainUntil: stamp(p.RetainUntil),
	}
}

func positionToWire(p domain.Position) *ambulancev1.Position {
	return &ambulancev1.Position{
		VehicleId:      p.VehicleID,
		LatitudeMicro:  int32(p.LatitudeMicro),
		LongitudeMicro: int32(p.LongitudeMicro),
		SpeedKph:       int32(p.SpeedKph),
		AccuracyMetres: int32(p.AccuracyMetres),
		Source:         p.Source, OccurredAt: stamp(p.At),
		Stale: p.Stale, Known: p.Known,
	}
}

func etaToWire(e domain.ETA) *ambulancev1.ETA {
	return &ambulancev1.ETA{
		VehicleId: e.VehicleID, TripId: e.TripID,
		Seconds: int32(e.Seconds), DistanceMetres: int32(e.DistanceMetres),
		Source: e.Source, OccurredAt: stamp(e.At), Known: e.Known,
	}
}

func metricsToWire(tripID string,
	m domain.TripMetrics) *ambulancev1.TripMetrics {

	gaps := make([]ambulancev1.Milestone, 0, len(m.Gaps))
	for _, gap := range m.Gaps {
		gaps = append(gaps, milestoneToWire[gap])
	}
	return &ambulancev1.TripMetrics{
		TripId:            tripID,
		ResponseSeconds:   int32(m.ResponseSeconds),
		ResponseKnown:     m.Answered,
		OnSceneSeconds:    int32(m.OnSceneSeconds),
		OnSceneKnown:      m.OnSceneKnown,
		TransportSeconds:  int32(m.TransportSeconds),
		TransportKnown:    m.TransportKnown,
		HandoverSeconds:   int32(m.HandoverSeconds),
		HandoverKnown:     m.HandoverKnown,
		TurnaroundSeconds: int32(m.TurnaroundSeconds),
		TurnaroundKnown:   m.TurnaroundKnown,
		TotalSeconds:      int32(m.TotalSeconds),
		TotalKnown:        m.TotalKnown,
		Gaps:              gaps,
	}
}

func intervalToWire(i domain.Interval) *ambulancev1.Interval {
	return &ambulancev1.Interval{
		Measured: int32(i.Measured), MeanSeconds: int32(i.MeanSeconds),
		MedianSeconds:  int32(i.MedianSeconds),
		P90Seconds:     int32(i.P90Seconds),
		LongestSeconds: int32(i.LongestSeconds),
		Unanswerable:   i.Unanswerable,
	}
}

func summaryToWire(s domain.ServiceSummary) *ambulancev1.ServiceSummary {
	return &ambulancev1.ServiceSummary{
		Requests: int32(s.Requests), Dispatched: int32(s.Dispatched),
		Completed: int32(s.Completed), Aborted: int32(s.Aborted),
		Cancelled:              int32(s.Cancelled),
		CancelledAfterDispatch: int32(s.CancelledAfterDispatch),
		Overridden:             int32(s.Overridden),
		IncompleteTimelines:    int32(s.IncompleteTimelines),
		VehiclesSeen:           int32(s.VehiclesSeen),
		UtilisationSeconds:     int64(s.UtilisationSeconds),
		Response:               intervalToWire(s.Response),
		OnScene:                intervalToWire(s.OnScene),
		Handover:               intervalToWire(s.Handover),
		Turnaround:             intervalToWire(s.Turnaround),
	}
}

func readinessSummaryToWire(
	s domain.ReadinessSummary) *ambulancev1.ReadinessSummary {

	missing := make(map[string]int32, len(s.MissingByItem))
	for code, count := range s.MissingByItem {
		missing[code] = int32(count)
	}
	return &ambulancev1.ReadinessSummary{
		Checked: int32(s.Checked), Passed: int32(s.Passed),
		Failed: int32(s.Failed), Overridden: int32(s.Overridden),
		MissingByItem: missing, Unanswerable: s.Unanswerable,
	}
}

func requestsToWire(
	requests []domain.Request) []*ambulancev1.Request {

	out := make([]*ambulancev1.Request, 0, len(requests))
	for _, request := range requests {
		out = append(out, requestToWire(request))
	}
	return out
}

func milestonesToWire(in []domain.Milestone) []ambulancev1.Milestone {
	out := make([]ambulancev1.Milestone, 0, len(in))
	for _, milestone := range in {
		out = append(out, milestoneToWire[milestone])
	}
	return out
}

func textsFromWire[W comparable, D ~string](wire []W,
	table map[W]D) []string {

	out := make([]string, 0, len(wire))
	for _, value := range wire {
		out = append(out, string(table[value]))
	}
	return out
}
