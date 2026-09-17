package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// FlowsheetRepo implements ports.FlowsheetRepository.
type FlowsheetRepo struct{ *Repository }

var _ ports.FlowsheetRepository = FlowsheetRepo{}

// InsertObservation writes one flowsheet value.
func (r FlowsheetRepo) InsertObservation(ctx context.Context, scope authctx.TenantScope,
	o domain.Observation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	observationID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(o.EpisodeID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertIcuObservation(ctx, sqlcgen.InsertIcuObservationParams{
		ObservationID: observationID, TenantID: tenantID, EpisodeID: episodeID,
		CodeSystem: o.CodeSystem, Code: o.Code, Display: o.Display,
		Dimension: string(o.Dimension),
		Value:     o.Value, Unit: o.Unit,
		RawValue: o.RawValue, RawUnit: o.RawUnit, Normalised: o.Normalised,
		Source: string(o.Source), Validation: string(o.Validation),
		DeviceID: o.Device.DeviceID, DeviceModel: o.Device.Model,
		DeviceChannel: o.Device.ChannelID,
		// A device that sent no clock reading stores NULL rather than the
		// epoch: the dashboard reads an absent reading as a feed that has
		// stopped, and a zero timestamp would read as 1970.
		DeviceMeasuredAt: stamp(o.Device.MeasuredAt),
		DeviceQuality:    o.Device.Quality,
		ObservedAt:       stamp(o.ObservedAt),
		RecordedAt:       stamp(o.RecordedAt),
		RecordedBy:       o.RecordedBy,
	})
}

// GetObservation reads one value.
func (r FlowsheetRepo) GetObservation(ctx context.Context, scope authctx.TenantScope,
	observationID string) (domain.Observation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Observation{}, err
	}
	id, err := uuid.Parse(observationID)
	if err != nil {
		return domain.Observation{}, notFound()
	}

	row, err := r.queries(ctx).GetIcuObservation(ctx, sqlcgen.GetIcuObservationParams{
		TenantID: tenantID, ObservationID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Observation{}, notFound()
	}
	if err != nil {
		return domain.Observation{}, err
	}
	return observationFrom(row), nil
}

// Decide confirms or rejects a pending device reading.
func (r FlowsheetRepo) Decide(ctx context.Context, scope authctx.TenantScope,
	o domain.Observation) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(o.ID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).DecideIcuObservation(ctx,
		sqlcgen.DecideIcuObservationParams{
			Validation: string(o.Validation), ValidatedBy: o.ValidatedBy,
			ValidatedAt: stamp(o.ValidatedAt), ValidationNote: o.ValidationNote,
			TenantID: tenantID, ObservationID: id,
		})
	if err != nil {
		return false, err
	}
	// Zero rows means somebody decided it first. A race, not an error: the
	// value is decided either way, and the second clinician needs to see the
	// first one's decision rather than a failure.
	return rows > 0, nil
}

// Observations reads the flowsheet.
func (r FlowsheetRepo) Observations(ctx context.Context, scope authctx.TenantScope,
	episodeID string, since time.Time, limit int32) (domain.ObservationList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuObservations(ctx, sqlcgen.ListIcuObservationsParams{
		TenantID: tenantID, EpisodeID: id, Since: stamp(since), RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make(domain.ObservationList, 0, len(rows))
	for _, row := range rows {
		out = append(out, observationFrom(row))
	}
	return out, nil
}

// Pending is the validation worklist.
func (r FlowsheetRepo) Pending(ctx context.Context, scope authctx.TenantScope,
	episodeID string, limit int32) (domain.ObservationList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPendingIcuObservations(ctx,
		sqlcgen.ListPendingIcuObservationsParams{
			TenantID: tenantID, EpisodeID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make(domain.ObservationList, 0, len(rows))
	for _, row := range rows {
		out = append(out, observationFrom(row))
	}
	return out, nil
}

func observationFrom(row sqlcgen.IcuObservation) domain.Observation {
	source := domain.SourceKind(row.Source)
	if source == "" {
		source = domain.SourceUnknown
	}
	validation := domain.Validation(row.Validation)
	if validation == "" {
		// An unreadable validation state defaults to pending, never to
		// confirmed: a value of unknown standing must not silently become one
		// a score may be computed from.
		validation = domain.ValidationPending
	}

	return domain.Observation{
		ID: row.ObservationID.String(), TenantID: row.TenantID.String(),
		EpisodeID:  row.EpisodeID.String(),
		CodeSystem: row.CodeSystem, Code: row.Code, Display: row.Display,
		Dimension: domain.Dimension(row.Dimension),
		Value:     row.Value, Unit: row.Unit,
		RawValue: row.RawValue, RawUnit: row.RawUnit, Normalised: row.Normalised,
		Source: source, Validation: validation,
		Device: domain.DeviceSource{
			DeviceID: row.DeviceID, Model: row.DeviceModel,
			ChannelID: row.DeviceChannel, MeasuredAt: timeOf(row.DeviceMeasuredAt),
			Quality: row.DeviceQuality,
		},
		ObservedAt: timeOf(row.ObservedAt), RecordedAt: timeOf(row.RecordedAt),
		RecordedBy:  row.RecordedBy,
		ValidatedBy: row.ValidatedBy, ValidatedAt: timeOf(row.ValidatedAt),
		ValidationNote: row.ValidationNote,
	}
}

// InsertBalanceEntry records a volume in or out.
func (r FlowsheetRepo) InsertBalanceEntry(ctx context.Context, scope authctx.TenantScope,
	e domain.BalanceEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	entryID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(e.EpisodeID)
	if err != nil {
		return notFound()
	}
	corrects, err := optionalUUID(e.Corrects)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIcuBalanceEntry(ctx, sqlcgen.InsertIcuBalanceEntryParams{
		EntryID: entryID, TenantID: tenantID, EpisodeID: episodeID,
		Direction: string(e.Direction), Route: e.Route, VolumeMl: e.VolumeML,
		OccurredAt: stamp(e.OccurredAt), RecordedAt: stamp(e.RecordedAt),
		RecordedBy: e.RecordedBy,
		Corrects:   corrects, CorrectionReason: e.CorrectionReason,
	})
}

// Supersede marks an entry corrected.
func (r FlowsheetRepo) Supersede(ctx context.Context, scope authctx.TenantScope,
	entryID, supersededBy string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(entryID)
	if err != nil {
		return false, notFound()
	}
	replacement, err := optionalUUID(supersededBy)
	if err != nil {
		return false, err
	}

	rows, err := r.queries(ctx).SupersedeIcuBalanceEntry(ctx,
		sqlcgen.SupersedeIcuBalanceEntryParams{
			SupersededBy: replacement, TenantID: tenantID, EntryID: id,
		})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// BalanceEntries reads a period's entries, superseded ones included: the
// totals exclude them and the record keeps them.
func (r FlowsheetRepo) BalanceEntries(ctx context.Context, scope authctx.TenantScope,
	episodeID string, from, to time.Time) ([]domain.BalanceEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuBalanceEntries(ctx,
		sqlcgen.ListIcuBalanceEntriesParams{
			TenantID: tenantID, EpisodeID: id,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.BalanceEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.BalanceEntry{
			ID: row.EntryID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(),
			Direction: domain.BalanceDirection(row.Direction),
			Route:     row.Route, VolumeML: row.VolumeMl,
			OccurredAt: timeOf(row.OccurredAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy:       row.RecordedBy,
			SupersededBy:     uuidOrEmpty(row.SupersededBy),
			Corrects:         uuidOrEmpty(row.Corrects),
			CorrectionReason: row.CorrectionReason,
		})
	}
	return out, nil
}
