package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
)

// BoardReport is the occupancy and pending-release dashboard
// (SRS-MORT-008).
//
// Behind its own permission and carrying no clinical detail: the projection
// has no field for a cause of death, which is what makes "without
// unnecessary clinical detail" a property of the type rather than of
// whoever writes the next screen.
type BoardReport struct {
	Rows      []domain.Board
	Occupancy domain.Occupancy
	// Truncated says the mortuary holds more cases than one dashboard may
	// read, so the figures come from part of it.
	Truncated bool
}

// Board reads the occupancy and pending-release dashboard (SRS-MORT-008).
func (s *Service) Board(ctx context.Context, facilityID string) (
	BoardReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return BoardReport{}, err
	}
	now := s.clock.Now()

	cases, err := s.cases.Cases(ctx, scope, ports.CaseFilter{
		States: []domain.CaseState{
			domain.CaseReceived, domain.CaseStored,
		},
		FacilityID: facilityID, Limit: reportPageSize,
	})
	if err != nil {
		return BoardReport{}, err
	}

	ids := make([]string, 0, len(cases))
	for _, c := range cases {
		ids = append(ids, c.ID)
	}

	// Everything the pending-release computation needs, read once for the
	// whole board rather than per row: a dashboard that issued four
	// queries per body is one a mortuary stops opening.
	auths, err := s.releases.Authorisations(ctx, scope, ids)
	if err != nil {
		return BoardReport{}, err
	}
	items, err := s.custody.Items(ctx, scope, ids)
	if err != nil {
		return BoardReport{}, err
	}
	requests, err := s.postmortems.Postmortems(ctx, scope, ids)
	if err != nil {
		return BoardReport{}, err
	}

	outstanding := map[string][]domain.Item{}
	blocking := map[string][]domain.Postmortem{}
	for _, c := range cases {
		outstanding[c.ID] = domain.Outstanding(items, c.ID)
		blocking[c.ID] = domain.Blocking(requests, c.ID)
	}

	pending := domain.PendingRelease(cases, s.config.Release, auths,
		outstanding, blocking)

	locations, err := s.storage.Locations(ctx, scope,
		ports.LocationFilter{
			FacilityID: facilityID, Limit: reportPageSize,
		})
	if err != nil {
		return BoardReport{}, err
	}
	occupied, err := s.storage.OccupiedLocations(ctx, scope)
	if err != nil {
		return BoardReport{}, err
	}

	return BoardReport{
		Rows:      domain.Summarise(cases, pending, now),
		Occupancy: domain.CountOccupancy(locations, occupied),
		Truncated: len(cases) >= reportPageSize ||
			len(locations) >= reportPageSize,
	}, nil
}

// SweepLongStay escalates bodies held past the deployment's limit
// (SRS-MORT-008).
//
// Run on a schedule. A body nobody has claimed becomes somebody's legal
// problem and then nobody's, and the point at which it should have been
// chased is weeks earlier than the point at which somebody notices.
func (s *Service) SweepLongStay(ctx context.Context, facilityID string) (
	int, error) {

	session, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return 0, err
	}
	if s.config.LongStayAfter <= 0 {
		return 0, nil
	}
	now := s.clock.Now()

	cases, err := s.cases.Cases(ctx, scope, ports.CaseFilter{
		States: []domain.CaseState{
			domain.CaseReceived, domain.CaseStored,
		},
		FacilityID: facilityID, Limit: reportPageSize,
	})
	if err != nil {
		return 0, err
	}

	raised := 0
	for _, c := range cases {
		if c.ReceivedAt.IsZero() ||
			now.Sub(c.ReceivedAt) < s.config.LongStayAfter {
			continue
		}
		days := int(now.Sub(c.ReceivedAt).Hours() / 24)
		// The reference and the days, and nothing else. A notice goes
		// further and under fewer controls than the record that produced
		// it, and this one would otherwise carry a name.
		if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
			return s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationLongStay, Subject: c.ID,
				FacilityID: c.FacilityID,
				Summary: "case " + c.Reference + " held for " +
					itoa(days) + " days",
			}, now)
		}); err != nil {
			return raised, err
		}
		raised++
	}
	return raised, nil
}
