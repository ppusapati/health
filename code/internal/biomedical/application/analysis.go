package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// AppendReadings records device telemetry (SRS-BIO-010).
//
// A batch, because a gateway reports a shift's worth at a time, and one
// transaction because a half-ingested batch is a meter reading that jumps
// backwards.
//
// Nothing here can reach a maintenance record: a reading informs a plan and
// can never alter what an engineer wrote.
func (s *Service) AppendReadings(ctx context.Context,
	in []domain.NewReadingInput) ([]domain.Reading, error) {

	session, scope, err := s.authorize(ctx, PermTelemetry)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	readings := make([]domain.Reading, 0, len(in))
	for _, one := range in {
		reading, err := domain.NewReading(s.ids.NewID(), session.TenantID, one,
			session.SubjectID, now)
		if err != nil {
			return nil, biomedicalError(err)
		}
		readings = append(readings, reading)
	}
	if len(readings) == 0 {
		return nil, nil
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Every reading names an asset that exists. A meter reading against
		// an unknown machine is a runtime plan that never comes due.
		seen := map[string]bool{}
		for _, reading := range readings {
			if seen[reading.AssetID] {
				continue
			}
			if _, err := s.assets.Asset(ctx, scope, reading.AssetID); err != nil {
				return err
			}
			seen[reading.AssetID] = true
		}
		if err := s.telemetry.AppendReadings(ctx, scope, readings); err != nil {
			return err
		}
		// One audit line for the batch. A record per reading would bury the
		// trail in telemetry, which is the one thing an audit log must not
		// become.
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.telemetry.append",
			ResourceType: "biomedical_reading", ResourceID: readings[0].ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(len(readings)) + " reading(s) over " + itoa(len(seen)) + " asset(s)",
		}, now)
	})
	if err != nil {
		return nil, biomedicalError(err)
	}
	return readings, nil
}

// ReadingFilter narrows a telemetry read.
type ReadingFilter struct {
	AssetID  string
	Metric   string
	From     time.Time
	To       time.Time
	PageSize int32
}

// Readings reads device telemetry.
func (s *Service) Readings(ctx context.Context, f ReadingFilter) (
	[]domain.Reading, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	readings, err := s.telemetry.Readings(ctx, scope, f.AssetID, f.Metric,
		f.From, f.To, clampPageSize(f.PageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return readings, nil
}

// AssetMetrics derives one machine's reliability figures (SRS-BIO-007).
func (s *Service) AssetMetrics(ctx context.Context, assetID string,
	from, to time.Time) (domain.Metrics, error) {

	_, scope, err := s.authorize(ctx, PermAnalyse)
	if err != nil {
		return domain.Metrics{}, err
	}
	asset, err := s.assets.Asset(ctx, scope, assetID)
	if err != nil {
		return domain.Metrics{}, biomedicalError(err)
	}
	metrics, err := s.metricsFor(ctx, scope, asset, from, to)
	if err != nil {
		return domain.Metrics{}, biomedicalError(err)
	}
	return metrics, nil
}

func (s *Service) metricsFor(ctx context.Context, scope authctx.TenantScope,
	asset domain.Asset, from, to time.Time) (domain.Metrics, error) {

	tickets, err := s.tickets.ForAssetBetween(ctx, scope, asset.ID, from, to,
		analysisPageSize)
	if err != nil {
		return domain.Metrics{}, err
	}
	plans, err := s.plans.Plans(ctx, scope, asset.ID, true, MaxPageSize)
	if err != nil {
		return domain.Metrics{}, err
	}
	completed, err := s.tickets.ClosedPlannedWork(ctx, scope, asset.ID, from, to)
	if err != nil {
		return domain.Metrics{}, err
	}
	return domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to, Tickets: tickets,
		Plans: plans, CompletedPM: completed,
	}), nil
}

// FleetMetrics ranks a set of assets, worst uptime first (SRS-BIO-007).
//
// Ordered by uptime rather than by failure count, because a machine that
// failed once for a week is a worse problem than one that failed five times
// for an hour.
func (s *Service) FleetMetrics(ctx context.Context, category string,
	from, to time.Time, pageSize int32) ([]domain.FleetLine, error) {

	_, scope, err := s.authorize(ctx, PermAnalyse)
	if err != nil {
		return nil, err
	}
	// Retired equipment is excluded: a decommissioned machine reports zero
	// uptime and would sit at the top of a list of things to worry about.
	assets, err := s.assets.Assets(ctx, scope, category, "", true,
		clampPageSize(pageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}

	lines := make([]domain.FleetLine, 0, len(assets))
	for _, asset := range assets {
		metrics, err := s.metricsFor(ctx, scope, asset, from, to)
		if err != nil {
			return nil, biomedicalError(err)
		}
		lines = append(lines, domain.FleetLine{
			AssetID: asset.ID, AssetTag: asset.Tag,
			Criticality: asset.Criticality, Metrics: metrics,
		})
	}
	return domain.Fleet(lines), nil
}

// Dispose records an asset leaving the hospital (SRS-BIO-011).
//
// The approver is the caller, never a name in the request: an approval field
// a client can fill in is an approval the requester can grant themselves.
func (s *Service) Dispose(ctx context.Context, in domain.DisposalInput) (
	domain.Disposal, error) {

	session, scope, err := s.authorize(ctx, PermDispose)
	if err != nil {
		return domain.Disposal{}, err
	}
	now := s.clock.Now()

	var disposal domain.Disposal
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		wasAt := asset.LocationID

		var updated domain.Asset
		disposal, updated, err = domain.Dispose(s.ids.NewID(), session.TenantID,
			in, asset, session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.disposals.InsertDisposal(ctx, scope, disposal); err != nil {
			return err
		}
		if err := s.assets.UpdateAsset(ctx, scope, updated,
			asset.Version); err != nil {
			return err
		}

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.asset.dispose",
			ResourceType: "biomedical_asset", ResourceID: asset.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  disposal.Method + ": " + disposal.Reason,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventAssetDisposed,
			"biomedical_asset", asset.ID, map[string]any{
				"asset_id":              asset.ID,
				"tag":                   asset.Tag,
				"method":                disposal.Method,
				"sanitisation_required": disposal.SanitisationRequired,
				"approved_by":           disposal.ApprovedBy,
			}, now); err != nil {
			return err
		}
		// The room loses whatever the machine was contributing, the moment it
		// goes.
		return s.publishCapabilities(ctx, session, scope, wasAt, now)
	})
	if err != nil {
		return domain.Disposal{}, biomedicalError(err)
	}
	return disposal, nil
}

// Disposal reads what happened to one asset.
func (s *Service) Disposal(ctx context.Context, assetID string) (
	domain.Disposal, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Disposal{}, err
	}
	disposal, err := s.disposals.Disposal(ctx, scope, assetID)
	if err != nil {
		return domain.Disposal{}, biomedicalError(err)
	}
	return disposal, nil
}

// Disposals lists what left the hospital over a period.
func (s *Service) Disposals(ctx context.Context, from, to time.Time,
	pageSize int32) ([]domain.Disposal, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	disposals, err := s.disposals.Disposals(ctx, scope, from, to,
		clampPageSize(pageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return disposals, nil
}
