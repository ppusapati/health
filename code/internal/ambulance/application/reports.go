package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
)

// ServiceReport is what a service reports about itself (SRS-AMB-008).
type ServiceReport struct {
	Summary domain.ServiceSummary
	// Truncated says the window held more rows than one report may read,
	// so the figures below are computed from part of it. A summary
	// silently derived from the first five thousand rows of a busy month
	// is a set of numbers nobody should act on.
	Truncated bool
}

// ServiceSummary reports response, turnaround, utilisation and cancellation
// (SRS-AMB-008).
//
// Every figure derives from the trip milestones. A trip whose timeline has a
// gap is excluded from the figures it cannot support and counted in
// IncompleteTimelines beside them, rather than having the gap filled in with
// a guess: a service whose worst calls have incomplete timelines would
// otherwise report the best response times in the region.
func (s *Service) ServiceSummary(ctx context.Context,
	in ListTripsInput) (ServiceReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return ServiceReport{}, err
	}

	trips, err := s.trips.Trips(ctx, scope, in.filter(reportPageSize))
	if err != nil {
		return ServiceReport{}, err
	}
	requests, err := s.requests.Requests(ctx, scope, ports.RequestFilter{
		FacilityID: in.FacilityID, From: in.From, To: in.To,
		Limit: reportPageSize,
	})
	if err != nil {
		return ServiceReport{}, err
	}

	return ServiceReport{
		Summary: domain.Summarise(requests, trips),
		Truncated: len(trips) >= reportPageSize ||
			len(requests) >= reportPageSize,
	}, nil
}

// TripMetrics reports one trip's intervals (SRS-AMB-008).
func (s *Service) TripMetrics(ctx context.Context, tripID string) (
	domain.TripMetrics, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return domain.TripMetrics{}, err
	}
	trip, err := s.trips.Trip(ctx, scope, tripID)
	if err != nil {
		return domain.TripMetrics{}, err
	}
	request, err := s.requests.Request(ctx, scope, trip.RequestID)
	if err != nil {
		return domain.TripMetrics{}, err
	}
	return domain.Measure(request, trip), nil
}
