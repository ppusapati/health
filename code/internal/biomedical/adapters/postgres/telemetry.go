package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// TelemetryRepo implements ports.TelemetryRepository (SRS-BIO-010).
//
// Append and read. There is deliberately no update, no delete, and no method
// here that touches a ticket, a plan or an asset: a reading can tell a planner
// that a pump has run four thousand hours, and it can never alter what an
// engineer wrote about the last repair. That is SRS-BIO-010's acceptance made
// a property of this type rather than a rule somebody has to remember.
type TelemetryRepo struct{ *Repository }

var _ ports.TelemetryRepository = TelemetryRepo{}

// AppendReading records one sample.
func (r TelemetryRepo) AppendReading(ctx context.Context,
	scope authctx.TenantScope, reading domain.Reading) error {

	return r.AppendReadings(ctx, scope, []domain.Reading{reading})
}

// AppendReadings records a batch.
//
// A gateway flushing after a network outage sends hundreds at once, and one
// call per reading would make the flush slower than the outage.
func (r TelemetryRepo) AppendReadings(ctx context.Context,
	scope authctx.TenantScope, readings []domain.Reading) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	queries := r.queries(ctx)
	for _, reading := range readings {
		readingID, err := uuid.Parse(reading.ID)
		if err != nil {
			return notFound()
		}
		assetID, err := uuid.Parse(reading.AssetID)
		if err != nil {
			return notFound()
		}

		if err := queries.InsertReading(ctx, sqlcgen.InsertReadingParams{
			ReadingID: readingID, TenantID: tenantID, AssetID: assetID,
			Metric: reading.Metric, Value: reading.Value, Unit: reading.Unit,
			Source: reading.Source, Ingested: reading.Ingested,
			ObservedAt: stamp(reading.ObservedAt),
			RecordedAt: stamp(reading.RecordedAt),
			RecordedBy: reading.RecordedBy,
		}); err != nil {
			return err
		}
	}
	return nil
}

// Readings reads one asset's samples over a period.
func (r TelemetryRepo) Readings(ctx context.Context,
	scope authctx.TenantScope, assetID, metric string, from, to time.Time,
	limit int32) ([]domain.Reading, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListReadings(ctx, sqlcgen.ListReadingsParams{
		TenantID: tenantID, AssetID: id, Metric: metric,
		PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return readingsFrom(rows), nil
}

// LatestByMetric is the newest reading per asset, by observation.
func (r TelemetryRepo) LatestByMetric(ctx context.Context,
	scope authctx.TenantScope, metric string) ([]domain.Reading, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListLatestReadings(ctx,
		sqlcgen.ListLatestReadingsParams{TenantID: tenantID, Metric: metric})
	if err != nil {
		return nil, err
	}
	return readingsFrom(rows), nil
}

func readingsFrom(rows []sqlcgen.BiomedicalReading) []domain.Reading {
	out := make([]domain.Reading, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Reading{
			ID: row.ReadingID.String(), TenantID: row.TenantID.String(),
			AssetID: row.AssetID.String(), Metric: row.Metric,
			Value: row.Value, Unit: row.Unit,
			Source: row.Source, Ingested: row.Ingested,
			ObservedAt: timeOf(row.ObservedAt),
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out
}

// DisposalRepo implements ports.DisposalRepository (SRS-BIO-011).
type DisposalRepo struct{ *Repository }

var _ ports.DisposalRepository = DisposalRepo{}

// InsertDisposal records an asset leaving the hospital.
func (r DisposalRepo) InsertDisposal(ctx context.Context,
	scope authctx.TenantScope, d domain.Disposal) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	disposalID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	assetID, err := uuid.Parse(d.AssetID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDisposal(ctx, sqlcgen.InsertDisposalParams{
		DisposalID: disposalID, TenantID: tenantID, AssetID: assetID,
		AssetTag: d.AssetTag, Method: d.Method, Reason: d.Reason,
		RequestedBy: d.RequestedBy, ApprovedBy: d.ApprovedBy,
		ApprovedAt:              stamp(d.ApprovedAt),
		SanitisationRequired:    d.SanitisationRequired,
		SanitisationMethod:      d.SanitisationMethod,
		SanitisationCertificate: d.SanitisationCertificate,
		SanitisedBy:             d.SanitisedBy,
		Recipient:               d.Recipient,
		ProceedsMinor:           d.ProceedsMinor,
		DisposedAt:              stamp(d.DisposedAt),
		RecordedBy:              d.RecordedBy,
	})
}

// Disposal reads one asset's disposal record.
func (r DisposalRepo) Disposal(ctx context.Context, scope authctx.TenantScope,
	assetID string) (domain.Disposal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Disposal{}, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return domain.Disposal{}, notFound()
	}

	row, err := r.queries(ctx).GetDisposal(ctx, sqlcgen.GetDisposalParams{
		TenantID: tenantID, AssetID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Disposal{}, notFound()
	}
	if err != nil {
		return domain.Disposal{}, err
	}
	return disposalFrom(row), nil
}

// Disposals reads what left over a period.
func (r DisposalRepo) Disposals(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time, limit int32) (
	[]domain.Disposal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListDisposals(ctx, sqlcgen.ListDisposalsParams{
		TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
		RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Disposal, 0, len(rows))
	for _, row := range rows {
		out = append(out, disposalFrom(row))
	}
	return out, nil
}

func disposalFrom(row sqlcgen.BiomedicalDisposal) domain.Disposal {
	return domain.Disposal{
		ID: row.DisposalID.String(), TenantID: row.TenantID.String(),
		AssetID: row.AssetID.String(), AssetTag: row.AssetTag,
		Method: row.Method, Reason: row.Reason,
		RequestedBy: row.RequestedBy, ApprovedBy: row.ApprovedBy,
		ApprovedAt:              timeOf(row.ApprovedAt),
		SanitisationRequired:    row.SanitisationRequired,
		SanitisationMethod:      row.SanitisationMethod,
		SanitisationCertificate: row.SanitisationCertificate,
		SanitisedBy:             row.SanitisedBy,
		Recipient:               row.Recipient,
		ProceedsMinor:           row.ProceedsMinor,
		DisposedAt:              timeOf(row.DisposedAt),
		RecordedBy:              row.RecordedBy,
	}
}
