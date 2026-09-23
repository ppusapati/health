package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RaiseRequestInput is a call for an ambulance (SRS-AMB-001).
type RaiseRequestInput struct {
	Kind                  string
	Priority              string
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

// RaiseRequest puts a call in the dispatch queue (SRS-AMB-001).
func (s *Service) RaiseRequest(ctx context.Context, in RaiseRequestInput) (
	domain.Request, error) {

	session, scope, err := s.authorize(ctx, PermRequest)
	if err != nil {
		return domain.Request{}, err
	}
	now := s.clock.Now()

	var out domain.Request
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.checkPatient(ctx, scope, in.PatientID); err != nil {
			return err
		}
		for _, facility := range []string{
			in.OriginFacilityID, in.DestinationFacilityID,
		} {
			if err := s.checkFacility(ctx, scope, facility); err != nil {
				return err
			}
		}
		request, err := domain.RaiseRequest(s.ids.NewID(),
			session.TenantID, domain.NewRequestInput{
				Kind:      domain.RequestKind(in.Kind),
				Priority:  domain.Priority(in.Priority),
				PatientID: in.PatientID, EncounterID: in.EncounterID,
				OriginName: in.OriginName, OriginAddress: in.OriginAddress,
				OriginFacilityID:      in.OriginFacilityID,
				DestinationName:       in.DestinationName,
				DestinationAddress:    in.DestinationAddress,
				DestinationFacilityID: in.DestinationFacilityID,
				ClinicalNeed:          in.ClinicalNeed,
				RequiredCapabilities:  in.RequiredCapabilities,
			}, session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.requests.InsertRequest(ctx, scope, request); err != nil {
			return err
		}
		out = request

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.request.raised",
			ResourceType: "ambulance.request", ResourceID: request.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind":     string(request.Kind),
				"priority": string(request.Priority),
			}),
		}, now); err != nil {
			return err
		}
		// Identifiers and a priority. Not the address and not the
		// clinical need: an event stream is read by more systems and
		// under fewer controls than the record it describes.
		return s.appendEvent(ctx, session, EventRequestRaised,
			"ambulance.request", request.ID, map[string]any{
				"kind":     string(request.Kind),
				"priority": string(request.Priority),
			}, now)
	})
	if err != nil {
		return domain.Request{}, err
	}
	return out, nil
}

// CancelRequestInput stands a call down (SRS-AMB-001, SRS-AMB-008).
type CancelRequestInput struct {
	RequestID string
	Reason    string
	Version   int64
}

// CancelRequest stands a call down (SRS-AMB-001).
func (s *Service) CancelRequest(ctx context.Context,
	in CancelRequestInput) (domain.Request, error) {

	session, scope, err := s.authorize(ctx, PermRequest)
	if err != nil {
		return domain.Request{}, err
	}
	now := s.clock.Now()

	var out domain.Request
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.requests.Request(ctx, scope, in.RequestID)
		if err != nil {
			return err
		}
		if err := request.Cancel(in.Reason, session.SubjectID,
			now); err != nil {
			return ambulanceError(err)
		}
		if err := s.requests.UpdateRequest(ctx, scope, request,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		request.Version = in.Version + 1
		out = request

		// A call stood down after a vehicle was sent is a different
		// problem from one stood down before, so the trip is aborted
		// rather than left running.
		if request.TripID != "" {
			trip, err := s.trips.Trip(ctx, scope, request.TripID)
			if err == nil && trip.State == domain.TripActive {
				if err := trip.Abort(in.Reason, session.SubjectID,
					now); err != nil {
					return ambulanceError(err)
				}
				if err := s.trips.UpdateTrip(ctx, scope, trip,
					trip.Version); err != nil {
					return ambulanceError(err)
				}
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.request.cancelled",
			ResourceType: "ambulance.request", ResourceID: request.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
		}, now)
	})
	if err != nil {
		return domain.Request{}, err
	}
	return out, nil
}

// Request reads one call (SRS-AMB-001).
func (s *Service) Request(ctx context.Context, id string) (
	domain.Request, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Request{}, err
	}
	return s.requests.Request(ctx, scope, id)
}

// ListRequestsInput narrows a call list.
type ListRequestsInput struct {
	States     []string
	Priorities []string
	Kinds      []string
	FacilityID string
	PatientID  string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

func (in ListRequestsInput) filter(limit int32) ports.RequestFilter {
	states := make([]domain.RequestState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.RequestState(state))
	}
	priorities := make([]domain.Priority, 0, len(in.Priorities))
	for _, priority := range in.Priorities {
		priorities = append(priorities, domain.Priority(priority))
	}
	kinds := make([]domain.RequestKind, 0, len(in.Kinds))
	for _, kind := range in.Kinds {
		kinds = append(kinds, domain.RequestKind(kind))
	}
	return ports.RequestFilter{
		States: states, Priorities: priorities, Kinds: kinds,
		FacilityID: in.FacilityID, PatientID: in.PatientID,
		From: in.From, To: in.To, Limit: limit, Offset: in.Offset,
	}
}

// ListRequests reads calls (SRS-AMB-001).
func (s *Service) ListRequests(ctx context.Context, in ListRequestsInput) (
	[]domain.Request, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.requests.Requests(ctx, scope,
		in.filter(clampPageSize(in.PageSize)))
}

// DispatchQueue reads the queued calls in the order they should be answered
// (SRS-AMB-001).
//
// Priority first, then the oldest waiting. A queue in arrival order sends the
// next vehicle to a booked discharge while a cardiac arrest waits; one on
// priority alone leaves the oldest urgent call there all afternoon.
func (s *Service) DispatchQueue(ctx context.Context, facilityID string) (
	[]domain.Request, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	requests, err := s.requests.Requests(ctx, scope, ports.RequestFilter{
		States:     []domain.RequestState{domain.RequestQueued},
		FacilityID: facilityID, Limit: reportPageSize,
	})
	if err != nil {
		return nil, err
	}
	return domain.Queue(requests), nil
}

// DispatchInput assigns a vehicle to a call (SRS-AMB-003).
type DispatchInput struct {
	RequestID string
	VehicleID string
	ShiftID   string
	// OverrideReason is required when a rule would refuse the dispatch: a
	// vehicle off the run, a lapsed readiness check, a crew not on duty, a
	// missing capability. The overriding person is the caller.
	OverrideReason string
}

// Dispatch sends a vehicle to a call (SRS-AMB-002, SRS-AMB-003).
//
// The permission to override is separate from the permission to dispatch, so
// a dispatcher who can send the available vehicles cannot, by that alone,
// send one that failed its check.
func (s *Service) Dispatch(ctx context.Context, in DispatchInput) (
	domain.Trip, error) {

	session, scope, err := s.authorize(ctx, PermDispatch)
	if err != nil {
		return domain.Trip{}, err
	}
	if in.OverrideReason != "" &&
		!session.HasPermission(PermDispatchOverride) {
		return domain.Trip{}, rpcerr.PermissionDenied("AMB_FORBIDDEN",
			"this caller may not "+PermDispatchOverride)
	}
	now := s.clock.Now()

	overrideBy := ""
	if in.OverrideReason != "" {
		overrideBy = session.SubjectID
	}

	var out domain.Trip
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.requests.Request(ctx, scope, in.RequestID)
		if err != nil {
			return err
		}
		vehicle, err := s.vehicles.Vehicle(ctx, scope, in.VehicleID)
		if err != nil {
			return err
		}
		shift, err := s.shifts.Shift(ctx, scope, in.ShiftID)
		if err != nil {
			return err
		}

		trip, err := domain.Dispatch(s.ids.NewID(), session.TenantID,
			request, vehicle, shift, overrideBy, in.OverrideReason,
			session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.trips.InsertTrip(ctx, scope, trip); err != nil {
			return err
		}

		// The call and the vehicle move together with the trip: a
		// request still reading "queued" is one a second dispatcher
		// sends a second vehicle to.
		request.State = domain.RequestAssigned
		request.TripID = trip.ID
		if err := s.requests.UpdateRequest(ctx, scope, request,
			request.Version); err != nil {
			return ambulanceError(err)
		}
		vehicle.State = domain.VehicleOnTrip
		if err := s.vehicles.UpdateVehicle(ctx, scope, vehicle,
			vehicle.Version); err != nil {
			return ambulanceError(err)
		}
		out = trip

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.trip.dispatched",
			ResourceType: "ambulance.trip", ResourceID: trip.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.OverrideReason,
			Context: auditContext(map[string]string{
				"request_id": trip.RequestID,
				"vehicle_id": trip.VehicleID,
				"overridden": boolText(trip.Overridden()),
			}),
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTripDispatched,
			"ambulance.trip", trip.ID, map[string]any{
				"request_id": trip.RequestID,
				"vehicle_id": trip.VehicleID,
				"priority":   string(request.Priority),
				"overridden": trip.Overridden(),
			}, now); err != nil {
			return err
		}
		if !trip.Overridden() {
			return nil
		}
		// A vehicle sent that a rule would have refused is not a
		// refusal and not a line in a log either.
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationOverriddenDispatch, Subject: trip.ID,
			FacilityID: trip.FacilityID,
			Summary: "vehicle " + trip.VehicleID +
				" dispatched under override: " + in.OverrideReason,
		}, now)
	})
	if err != nil {
		return domain.Trip{}, err
	}
	return out, nil
}

// RecordMilestoneInput marks a point on a trip's timeline (SRS-AMB-003).
type RecordMilestoneInput struct {
	TripID    string
	Milestone string
	At        time.Time
	Note      string
	Version   int64
}

// RecordMilestone adds a point to a trip's timeline (SRS-AMB-003).
//
// Going clear finishes the trip and puts the vehicle back on the run, which
// is why the vehicle is read and written in the same transaction: a vehicle
// left reading "on_trip" is one the board never offers again.
func (s *Service) RecordMilestone(ctx context.Context,
	in RecordMilestoneInput) (domain.Trip, error) {

	session, scope, err := s.authorize(ctx, PermTimeline)
	if err != nil {
		return domain.Trip{}, err
	}
	now := s.clock.Now()
	at := in.At
	if at.IsZero() {
		at = now
	}

	var out domain.Trip
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		trip, err := s.trips.Trip(ctx, scope, in.TripID)
		if err != nil {
			return err
		}
		before := trip.State
		if err := trip.RecordMilestone(domain.Milestone(in.Milestone),
			in.Note, session.SubjectID, at); err != nil {
			return ambulanceError(err)
		}
		record := trip.Milestones[len(trip.Milestones)-1]
		// The version is checked only when the trip row itself changes,
		// which is when the crew goes clear. An ordinary milestone is an
		// insert the unique index already guards — one original per point
		// — and refusing it for a stale read would mean a crew whose
		// tablet has not refreshed cannot record that they arrived.
		if err := s.trips.AppendMilestone(ctx, scope, s.ids.NewID(),
			trip.ID, record); err != nil {
			return err
		}
		if trip.State != before {
			if err := s.trips.UpdateTrip(ctx, scope, trip,
				in.Version); err != nil {
				return ambulanceError(err)
			}
			trip.Version = in.Version + 1
			if err := s.finishTrip(ctx, session, scope, trip,
				now); err != nil {
				return err
			}
		}
		out = trip
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.trip.milestone",
			ResourceType: "ambulance.trip", ResourceID: trip.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"milestone": in.Milestone,
			}),
		}, now)
	})
	if err != nil {
		return domain.Trip{}, err
	}
	return out, nil
}

// finishTrip closes out a completed trip: the call is completed and the
// vehicle goes back on the board.
func (s *Service) finishTrip(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope, trip domain.Trip,
	now time.Time) error {

	request, err := s.requests.Request(ctx, scope, trip.RequestID)
	if err != nil {
		return err
	}
	if request.State == domain.RequestAssigned {
		request.State = domain.RequestCompleted
		if err := s.requests.UpdateRequest(ctx, scope, request,
			request.Version); err != nil {
			return ambulanceError(err)
		}
	}

	vehicle, err := s.vehicles.Vehicle(ctx, scope, trip.VehicleID)
	if err != nil {
		return err
	}
	if vehicle.State == domain.VehicleOnTrip {
		// Back on the run only while the check that put it there is
		// still in date; otherwise it comes back off the board, which is
		// what a lapsed check should mean.
		if vehicle.Ready(now) {
			vehicle.State = domain.VehicleAvailable
		} else {
			vehicle.State = domain.VehicleOutOfService
			vehicle.OutOfServiceReason = "readiness check has lapsed"
		}
		if err := s.vehicles.UpdateVehicle(ctx, scope, vehicle,
			vehicle.Version); err != nil {
			return ambulanceError(err)
		}
	}
	return s.appendEvent(ctx, session, EventTripCompleted,
		"ambulance.trip", trip.ID, map[string]any{
			"request_id": trip.RequestID,
			"vehicle_id": trip.VehicleID,
		}, now)
}

// AmendMilestoneInput corrects a recorded time (SRS-AMB-003).
type AmendMilestoneInput struct {
	TripID    string
	Milestone string
	At        time.Time
	Reason    string
}

// AmendMilestone corrects a time, keeping what it corrected (SRS-AMB-003).
func (s *Service) AmendMilestone(ctx context.Context,
	in AmendMilestoneInput) (domain.Trip, error) {

	session, scope, err := s.authorize(ctx, PermTimeline)
	if err != nil {
		return domain.Trip{}, err
	}
	now := s.clock.Now()

	var out domain.Trip
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		trip, err := s.trips.Trip(ctx, scope, in.TripID)
		if err != nil {
			return err
		}
		if err := trip.AmendMilestone(domain.Milestone(in.Milestone),
			in.At, in.Reason, session.SubjectID, now); err != nil {
			return ambulanceError(err)
		}
		record := trip.Milestones[len(trip.Milestones)-1]
		if err := s.trips.AppendMilestone(ctx, scope, s.ids.NewID(),
			trip.ID, record); err != nil {
			return err
		}
		out = trip
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.trip.milestone_amended",
			ResourceType: "ambulance.trip", ResourceID: trip.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
			Context: auditContext(map[string]string{
				"milestone": in.Milestone,
			}),
		}, now)
	})
	if err != nil {
		return domain.Trip{}, err
	}
	return out, nil
}

// AbortTripInput stands a trip down (SRS-AMB-003).
type AbortTripInput struct {
	TripID  string
	Reason  string
	Version int64
}

// AbortTrip stands a running trip down (SRS-AMB-003).
func (s *Service) AbortTrip(ctx context.Context, in AbortTripInput) (
	domain.Trip, error) {

	session, scope, err := s.authorize(ctx, PermDispatch)
	if err != nil {
		return domain.Trip{}, err
	}
	now := s.clock.Now()

	var out domain.Trip
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		trip, err := s.trips.Trip(ctx, scope, in.TripID)
		if err != nil {
			return err
		}
		if err := trip.Abort(in.Reason, session.SubjectID, now); err != nil {
			return ambulanceError(err)
		}
		if err := s.trips.UpdateTrip(ctx, scope, trip,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		trip.Version = in.Version + 1
		out = trip

		// The call goes back in the queue. A trip stood down leaves a
		// patient who still needs an ambulance, and a request left
		// reading "assigned" is a call that has fallen off the board
		// with nobody going to it. A request somebody cancelled stays
		// cancelled.
		request, err := s.requests.Request(ctx, scope, trip.RequestID)
		if err != nil {
			return err
		}
		if request.State == domain.RequestAssigned {
			request.State = domain.RequestQueued
			request.TripID = ""
			if err := s.requests.UpdateRequest(ctx, scope, request,
				request.Version); err != nil {
				return ambulanceError(err)
			}
		}

		vehicle, err := s.vehicles.Vehicle(ctx, scope, trip.VehicleID)
		if err != nil {
			return err
		}
		if vehicle.State == domain.VehicleOnTrip && vehicle.Ready(now) {
			vehicle.State = domain.VehicleAvailable
			if err := s.vehicles.UpdateVehicle(ctx, scope, vehicle,
				vehicle.Version); err != nil {
				return ambulanceError(err)
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.trip.aborted",
			ResourceType: "ambulance.trip", ResourceID: trip.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
		}, now)
	})
	if err != nil {
		return domain.Trip{}, err
	}
	return out, nil
}

// Trip reads one trip and its timeline (SRS-AMB-003).
func (s *Service) Trip(ctx context.Context, id string) (domain.Trip, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Trip{}, err
	}
	return s.trips.Trip(ctx, scope, id)
}

// ListTripsInput narrows a trip list.
type ListTripsInput struct {
	States     []string
	VehicleID  string
	FacilityID string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

func (in ListTripsInput) filter(limit int32) ports.TripFilter {
	states := make([]domain.TripState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.TripState(state))
	}
	return ports.TripFilter{
		States: states, VehicleID: in.VehicleID,
		FacilityID: in.FacilityID, From: in.From, To: in.To,
		Limit: limit, Offset: in.Offset,
	}
}

// ListTrips reads trips (SRS-AMB-003).
func (s *Service) ListTrips(ctx context.Context, in ListTripsInput) (
	[]domain.Trip, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.trips.Trips(ctx, scope, in.filter(clampPageSize(in.PageSize)))
}

// TimelineGaps reports the points a finished trip never recorded
// (SRS-AMB-003).
//
// Reported rather than filled in with a guess: a trip that reached the
// hospital with no "at scene" time has a response time nobody can compute,
// and a service whose worst calls have incomplete timelines would otherwise
// report the best response times in the region.
func (s *Service) TimelineGaps(ctx context.Context, tripID string) (
	[]domain.Milestone, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	trip, err := s.trips.Trip(ctx, scope, tripID)
	if err != nil {
		return nil, err
	}
	return domain.TimelineGaps(trip), nil
}

func boolText(b bool) string {
	if b {
		return "true"
	}
	return "false"
}
