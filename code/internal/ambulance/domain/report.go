package domain

import (
	"sort"
	"time"
)

// Reporting (SRS-AMB-008).
//
// SRS-AMB-008's acceptance is that the metrics derive from the trip
// milestones, and every figure here does. A stored response time and the
// timeline behind it disagree the first time somebody corrects an arrival,
// and the stored one is the one on the board — which is the one the service
// is judged on.
//
// Two shapes are deliberate. A trip whose timeline has a gap is counted as a
// trip and excluded from the figure that needs the missing point, rather than
// dropped: a service whose worst calls have incomplete timelines would
// otherwise report the best response times in the region. And a cancellation
// is counted whether or not a vehicle went, because "we cancelled a fifth of
// our calls" and "a fifth of our calls stood down after we arrived" are
// different problems.

// TripMetrics is one trip reduced to its intervals (SRS-AMB-008).
type TripMetrics struct {
	TripID    string
	RequestID string
	VehicleID string
	Priority  Priority

	// ResponseSeconds is request to at-scene: the number the public asks
	// about. Zero with Answered false when either point is missing.
	ResponseSeconds int
	Answered        bool

	// OnSceneSeconds is at-scene to left-scene.
	OnSceneSeconds int
	OnSceneKnown   bool

	// TransportSeconds is left-scene to at-destination.
	TransportSeconds int
	TransportKnown   bool

	// HandoverSeconds is at-destination to handover: the number an
	// emergency department is judged on, and the one that turns an
	// ambulance into a corridor.
	HandoverSeconds int
	HandoverKnown   bool

	// TurnaroundSeconds is at-destination to clear: how long before the
	// vehicle is available again.
	TurnaroundSeconds int
	TurnaroundKnown   bool

	// TotalSeconds is dispatched to clear.
	TotalSeconds int
	TotalKnown   bool

	// Overridden reports a trip sent against a blocker (SRS-AMB-002).
	Overridden bool
	// Gaps are the milestones the timeline never recorded.
	Gaps []Milestone
}

// Measure reduces one trip to its intervals (SRS-AMB-003, SRS-AMB-008).
func Measure(request Request, trip Trip) TripMetrics {
	out := TripMetrics{
		TripID: trip.ID, RequestID: trip.RequestID,
		VehicleID: trip.VehicleID, Priority: request.Priority,
		Overridden: trip.Overridden(), Gaps: TimelineGaps(trip),
	}

	at := func(m Milestone) (time.Time, bool) { return trip.MilestoneAt(m) }
	span := func(from, to time.Time) (int, bool) {
		if from.IsZero() || to.IsZero() || to.Before(from) {
			return 0, false
		}
		return int(to.Sub(from).Seconds()), true
	}

	scene, haveScene := at(MilestoneAtScene)
	if haveScene && !request.RequestedAt.IsZero() {
		out.ResponseSeconds, out.Answered = span(request.RequestedAt, scene)
	}

	left, haveLeft := at(MilestoneLeftScene)
	if haveScene && haveLeft {
		out.OnSceneSeconds, out.OnSceneKnown = span(scene, left)
	}

	destination, haveDestination := at(MilestoneAtDestination)
	if haveLeft && haveDestination {
		out.TransportSeconds, out.TransportKnown = span(left, destination)
	}

	handover, haveHandover := at(MilestoneHandover)
	if haveDestination && haveHandover {
		out.HandoverSeconds, out.HandoverKnown = span(destination, handover)
	}

	clear, haveClear := at(MilestoneClear)
	if haveDestination && haveClear {
		out.TurnaroundSeconds, out.TurnaroundKnown = span(destination, clear)
	}

	dispatched, haveDispatched := at(MilestoneDispatched)
	if haveDispatched && haveClear {
		out.TotalSeconds, out.TotalKnown = span(dispatched, clear)
	}
	return out
}

// Interval is one measured figure across a set of trips (SRS-AMB-008).
//
// Counts beside the averages rather than a percentage, because the
// percentage is what a reader computes and the counts are what they check.
// The ninetieth centile is here because a mean response time hides the call
// that took fifty minutes, and the fifty-minute call is the one that gets
// written about.
type Interval struct {
	Measured       int
	MeanSeconds    int
	MedianSeconds  int
	P90Seconds     int
	LongestSeconds int
	// Unanswerable is a set with nothing measured in it. Reported rather
	// than a mean of zero, which reads as a service that arrives instantly.
	Unanswerable bool
}

func summarise(values []int) Interval {
	out := Interval{Measured: len(values)}
	if len(values) == 0 {
		out.Unanswerable = true
		return out
	}
	sort.Ints(values)
	total := 0
	for _, value := range values {
		total += value
	}
	out.MeanSeconds = total / len(values)
	out.MedianSeconds = values[len(values)/2]
	out.LongestSeconds = values[len(values)-1]
	index := (len(values)*90 + 99) / 100
	if index > 0 {
		index--
	}
	out.P90Seconds = values[index]
	return out
}

// ServiceSummary reports a window of ambulance work (SRS-AMB-008).
type ServiceSummary struct {
	Requests   int
	Dispatched int
	Completed  int
	Aborted    int
	Cancelled  int
	// CancelledAfterDispatch is counted apart: "we cancelled a fifth of our
	// calls" and "a fifth of our calls stood down after we arrived" are
	// different problems.
	CancelledAfterDispatch int
	// Overridden counts trips sent against a blocker (SRS-AMB-002).
	Overridden int
	// IncompleteTimelines counts finished trips with a missing milestone.
	// Reported beside the figures rather than folded in, because a service
	// whose worst calls have incomplete timelines would otherwise report
	// the best response times in the region.
	IncompleteTimelines int

	Response   Interval
	OnScene    Interval
	Handover   Interval
	Turnaround Interval

	// UtilisationSeconds is how long vehicles spent on trips, and
	// AvailableSeconds how long the window was across the vehicles seen.
	// Two numbers rather than a percentage, for the same reason as above —
	// and because a percentage computed over a window nobody defined is a
	// number that means whatever its denominator was.
	UtilisationSeconds int
	VehiclesSeen       int
}

// Summarise counts a window of requests and trips (SRS-AMB-008).
//
// Requests and trips are matched on the request identifier; a request with no
// trip is a call nobody went to, which is exactly what the cancellation
// figure is about.
func Summarise(requests []Request, trips []Trip) ServiceSummary {
	out := ServiceSummary{}

	byRequest := map[string]Trip{}
	for _, trip := range trips {
		byRequest[trip.RequestID] = trip
	}

	vehicles := map[string]bool{}
	var response, onScene, handover, turnaround []int

	for _, request := range requests {
		out.Requests++
		trip, dispatched := byRequest[request.ID]
		if request.State == RequestCancelled {
			out.Cancelled++
			if dispatched {
				out.CancelledAfterDispatch++
			}
		}
		if !dispatched {
			continue
		}

		out.Dispatched++
		vehicles[trip.VehicleID] = true
		if trip.Overridden() {
			out.Overridden++
		}
		switch trip.State {
		case TripCompleted:
			out.Completed++
		case TripAborted:
			out.Aborted++
		}

		metrics := Measure(request, trip)
		if trip.State != TripActive && len(metrics.Gaps) > 0 {
			out.IncompleteTimelines++
		}
		if metrics.Answered {
			response = append(response, metrics.ResponseSeconds)
		}
		if metrics.OnSceneKnown {
			onScene = append(onScene, metrics.OnSceneSeconds)
		}
		if metrics.HandoverKnown {
			handover = append(handover, metrics.HandoverSeconds)
		}
		if metrics.TurnaroundKnown {
			turnaround = append(turnaround, metrics.TurnaroundSeconds)
		}
		if metrics.TotalKnown {
			out.UtilisationSeconds += metrics.TotalSeconds
		}
	}

	out.VehiclesSeen = len(vehicles)
	out.Response = summarise(response)
	out.OnScene = summarise(onScene)
	out.Handover = summarise(handover)
	out.Turnaround = summarise(turnaround)
	return out
}
