package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// SetThreshold configures a minimum stock level (SRS-BLD-017).
func (s *Service) SetThreshold(ctx context.Context, facilityID string,
	threshold domain.StockThreshold) error {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.inventory.SaveThreshold(ctx, scope, facilityID, threshold,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "bloodbank_threshold",
			ResourceID:   string(threshold.Class) + "/" + threshold.Group.String(),
			Outcome:      audit.OutcomeSuccess,
			Reason:       "minimum set to " + itoa(threshold.Minimum),
		}, now)
	})
}

// Stock is the inventory by component and group, with the alerts it raises
// (SRS-BLD-005, SRS-BLD-017).
func (s *Service) Stock(ctx context.Context, facilityID string) (
	[]domain.StockLevel, []domain.StockAlert, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, nil, err
	}
	now := s.clock.Now()

	units, err := s.inventory.Inventory(ctx, scope, MaxPageSize)
	if err != nil {
		return nil, nil, err
	}
	thresholds, err := s.inventory.Thresholds(ctx, scope, facilityID)
	if err != nil {
		return nil, nil, err
	}

	levels := domain.SummariseStock(units, s.config.ExpiryHorizon, now)
	return levels,
		domain.StockAlerts(levels, thresholds, s.config.ExpiryHorizon), nil
}

// Utilisation derives the component utilisation report (SRS-BLD-015).
//
// From the records, every time. A counter maintained alongside them drifts the
// first time anything is corrected, and this report is read to decide whether
// a hospital is transfusing too much.
func (s *Service) Utilisation(ctx context.Context, from, to time.Time) (
	domain.Utilisation, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Utilisation{}, err
	}
	if to.IsZero() {
		to = s.clock.Now()
	}
	if from.IsZero() {
		from = to.AddDate(0, -1, 0)
	}

	issues, err := s.crossmatch.IssuesInPeriod(ctx, scope, from, to, MaxPageSize)
	if err != nil {
		return domain.Utilisation{}, err
	}
	episodes, err := s.transfusion.EpisodesInPeriod(
		ctx, scope, from, to, MaxPageSize)
	if err != nil {
		return domain.Utilisation{}, err
	}
	reactions, err := s.transfusion.ReactionsInPeriod(
		ctx, scope, from, to, MaxPageSize)
	if err != nil {
		return domain.Utilisation{}, err
	}
	reservations, err := s.crossmatch.CountReservations(ctx, scope, from, to)
	if err != nil {
		return domain.Utilisation{}, err
	}
	discarded, err := s.inventory.CountDiscarded(ctx, scope, from, to)
	if err != nil {
		return domain.Utilisation{}, err
	}

	// The indication travels with the request, so the report can group
	// transfusions by why the blood was asked for — which is what a
	// utilisation review reads.
	indications := map[string]string{}
	for _, issue := range issues {
		if issue.RequestID == "" {
			continue
		}
		request, err := s.crossmatch.Request(ctx, scope, issue.RequestID)
		if err != nil {
			// A request that has gone is not a reason to fail the report; the
			// transfusion still counts, it just has no indication against it.
			continue
		}
		indications[issue.ComponentID] = request.Indication
	}

	report := domain.SummariseUtilisation(issues, episodes, reactions,
		reservations, indications, discarded)
	return report, nil
}
