package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// SupportRepo implements ports.SupportRepository.
type SupportRepo struct{ *Repository }

var _ ports.SupportRepository = SupportRepo{}

// InsertSupport records the start of organ support.
func (r SupportRepo) InsertSupport(ctx context.Context, scope authctx.TenantScope,
	s domain.Support) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	supportID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(s.EpisodeID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertIcuSupport(ctx, sqlcgen.InsertIcuSupportParams{
		SupportID: supportID, TenantID: tenantID, EpisodeID: episodeID,
		Kind: string(s.Kind), Label: s.Label, Modality: s.Modality,
		StartedAt: stamp(s.StartedAt), StartedBy: s.StartedBy,
	})
}

// StopSupport ends a run.
func (r SupportRepo) StopSupport(ctx context.Context, scope authctx.TenantScope,
	supportID, by, note string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(supportID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).StopIcuSupport(ctx, sqlcgen.StopIcuSupportParams{
		StoppedAt: stamp(at), StoppedBy: by, StopNote: note,
		TenantID: tenantID, SupportID: id,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Support reads an episode's organ support.
func (r SupportRepo) Support(ctx context.Context, scope authctx.TenantScope,
	episodeID string) ([]domain.Support, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuSupport(ctx, sqlcgen.ListIcuSupportParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Support, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Support{
			ID: row.SupportID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), Kind: domain.SupportKind(row.Kind),
			Label: row.Label, Modality: row.Modality,
			StartedAt: timeOf(row.StartedAt), StartedBy: row.StartedBy,
			StoppedAt: timeOf(row.StoppedAt), StoppedBy: row.StoppedBy,
			StopNote: row.StopNote,
		})
	}
	return out, nil
}

// InsertVentSetting records ventilator settings.
func (r SupportRepo) InsertVentSetting(ctx context.Context, scope authctx.TenantScope,
	s domain.VentSetting) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	settingID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(s.EpisodeID)
	if err != nil {
		return notFound()
	}
	supportID, err := optionalUUID(s.SupportID)
	if err != nil {
		return err
	}

	parameters, err := encodeFloats(s.Parameters)
	if err != nil {
		return err
	}
	measured, err := encodeFloats(s.Measured)
	if err != nil {
		return err
	}
	units, err := encodeStrings(s.Units)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIcuVentSetting(ctx, sqlcgen.InsertIcuVentSettingParams{
		SettingID: settingID, TenantID: tenantID, EpisodeID: episodeID,
		SupportID: supportID, Mode: s.Mode,
		Parameters: parameters, Measured: measured, Units: units,
		DeviceID:    s.DeviceID,
		EffectiveAt: stamp(s.EffectiveAt), RecordedAt: stamp(s.RecordedAt),
		RecordedBy: s.RecordedBy, ChangeReason: s.ChangeReason,
	})
}

// VentSettings reads the ventilator timeline.
func (r SupportRepo) VentSettings(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (domain.VentTimeline, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuVentSettings(ctx, sqlcgen.ListIcuVentSettingsParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make(domain.VentTimeline, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.VentSetting{
			ID: row.SettingID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), SupportID: uuidOrEmpty(row.SupportID),
			Mode:        row.Mode,
			Parameters:  decodeFloats(row.Parameters),
			Measured:    decodeFloats(row.Measured),
			Units:       decodeStrings(row.Units),
			DeviceID:    row.DeviceID,
			EffectiveAt: timeOf(row.EffectiveAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy, ChangeReason: row.ChangeReason,
		})
	}
	return out, nil
}

func encodeFloats(in map[string]float64) ([]byte, error) {
	if in == nil {
		in = map[string]float64{}
	}
	return json.Marshal(in)
}

func encodeStrings(in map[string]string) ([]byte, error) {
	if in == nil {
		in = map[string]string{}
	}
	return json.Marshal(in)
}

// decodeFloats returns an empty map on unreadable JSON rather than nil.
//
// A ventilator record whose parameters could not be decoded is a record with
// no parameters, and a nil map read as "PEEP 0" would be a setting nobody
// made.
func decodeFloats(raw []byte) map[string]float64 {
	out := map[string]float64{}
	if len(raw) == 0 {
		return out
	}
	_ = json.Unmarshal(raw, &out)
	return out
}

func decodeStrings(raw []byte) map[string]string {
	out := map[string]string{}
	if len(raw) == 0 {
		return out
	}
	_ = json.Unmarshal(raw, &out)
	return out
}

// InsertInfusion starts an infusion.
func (r SupportRepo) InsertInfusion(ctx context.Context, scope authctx.TenantScope,
	i domain.Infusion) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	infusionID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(i.EpisodeID)
	if err != nil {
		return notFound()
	}
	prescriptionID, err := optionalUUID(i.PrescriptionID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIcuInfusion(ctx, sqlcgen.InsertIcuInfusionParams{
		InfusionID: infusionID, TenantID: tenantID, EpisodeID: episodeID,
		PrescriptionID: prescriptionID,
		DrugCode:       i.DrugCode, DrugDisplay: i.DrugDisplay,
		ConcentrationAmount: i.ConcentrationAmount,
		ConcentrationUnit:   i.ConcentrationUnit,
		ConcentrationVolume: i.ConcentrationVolume,
		DoseUnit:            i.DoseUnit, WeightKg: i.WeightKg,
		StartedAt: stamp(i.StartedAt), StartedBy: i.StartedBy,
	})
}

// GetInfusion reads one infusion with its titrations.
func (r SupportRepo) GetInfusion(ctx context.Context, scope authctx.TenantScope,
	infusionID string) (domain.Infusion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Infusion{}, err
	}
	id, err := uuid.Parse(infusionID)
	if err != nil {
		return domain.Infusion{}, notFound()
	}

	row, err := r.queries(ctx).GetIcuInfusion(ctx, sqlcgen.GetIcuInfusionParams{
		TenantID: tenantID, InfusionID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Infusion{}, notFound()
	}
	if err != nil {
		return domain.Infusion{}, err
	}

	infusion := infusionFrom(row)
	titrations, err := r.titrations(ctx, tenantID, id)
	if err != nil {
		return domain.Infusion{}, err
	}
	infusion.Titrations = titrations
	return infusion, nil
}

func (r SupportRepo) titrations(ctx context.Context, tenantID, infusionID uuid.UUID) (
	[]domain.Titration, error) {

	rows, err := r.queries(ctx).ListIcuTitrations(ctx, sqlcgen.ListIcuTitrationsParams{
		TenantID: tenantID, InfusionID: infusionID,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Titration, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Titration{
			ID: row.TitrationID.String(), Rate: row.Rate, RateUnit: row.RateUnit,
			Dose:        row.Dose,
			EffectiveAt: timeOf(row.EffectiveAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy, DeviceID: row.DeviceID, Reason: row.Reason,
		})
	}
	return out, nil
}

// InsertTitration records a rate change.
func (r SupportRepo) InsertTitration(ctx context.Context, scope authctx.TenantScope,
	infusionID string, t domain.Titration) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	titrationID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	infusion, err := uuid.Parse(infusionID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertIcuTitration(ctx, sqlcgen.InsertIcuTitrationParams{
		TitrationID: titrationID, TenantID: tenantID, InfusionID: infusion,
		Rate: t.Rate, RateUnit: t.RateUnit, Dose: t.Dose,
		EffectiveAt: stamp(t.EffectiveAt), RecordedAt: stamp(t.RecordedAt),
		RecordedBy: t.RecordedBy, DeviceID: t.DeviceID, Reason: t.Reason,
	})
}

// StopInfusion takes an infusion down.
func (r SupportRepo) StopInfusion(ctx context.Context, scope authctx.TenantScope,
	infusionID, by string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(infusionID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).StopIcuInfusion(ctx, sqlcgen.StopIcuInfusionParams{
		StoppedAt: stamp(at), StoppedBy: by, TenantID: tenantID, InfusionID: id,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Infusions reads an episode's infusions with their titrations.
func (r SupportRepo) Infusions(ctx context.Context, scope authctx.TenantScope,
	episodeID string) ([]domain.Infusion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuInfusions(ctx, sqlcgen.ListIcuInfusionsParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Infusion, 0, len(rows))
	for _, row := range rows {
		infusion := infusionFrom(row)
		// The dose timeline is the record (SRS-ICU-005), so an infusion read
		// without it would be a rate nobody can account for.
		titrations, err := r.titrations(ctx, tenantID, row.InfusionID)
		if err != nil {
			return nil, err
		}
		infusion.Titrations = titrations
		out = append(out, infusion)
	}
	return out, nil
}

func infusionFrom(row sqlcgen.IcuInfusion) domain.Infusion {
	return domain.Infusion{
		ID: row.InfusionID.String(), TenantID: row.TenantID.String(),
		EpisodeID:      row.EpisodeID.String(),
		PrescriptionID: uuidOrEmpty(row.PrescriptionID),
		DrugCode:       row.DrugCode, DrugDisplay: row.DrugDisplay,
		ConcentrationAmount: row.ConcentrationAmount,
		ConcentrationUnit:   row.ConcentrationUnit,
		ConcentrationVolume: row.ConcentrationVolume,
		DoseUnit:            row.DoseUnit, WeightKg: row.WeightKg,
		StartedAt: timeOf(row.StartedAt), StartedBy: row.StartedBy,
		StoppedAt: timeOf(row.StoppedAt), StoppedBy: row.StoppedBy,
	}
}

// InsertDevice records a line, tube or drain going in.
func (r SupportRepo) InsertDevice(ctx context.Context, scope authctx.TenantScope,
	d domain.InvasiveDevice) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	deviceID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(d.EpisodeID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertIcuDevice(ctx, sqlcgen.InsertIcuDeviceParams{
		DeviceID: deviceID, TenantID: tenantID, EpisodeID: episodeID,
		Kind: d.Kind, Site: d.Site, Lumens: int32(d.Lumens),
		InsertedAt: stamp(d.InsertedAt), InsertedBy: d.InsertedBy,
		ReviewEverySeconds: int64(d.ReviewEvery / time.Second),
	})
}

// RemoveDevice takes a device out.
func (r SupportRepo) RemoveDevice(ctx context.Context, scope authctx.TenantScope,
	deviceID, by, reason string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(deviceID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).RemoveIcuDevice(ctx, sqlcgen.RemoveIcuDeviceParams{
		RemovedAt: stamp(at), RemovedBy: by, RemovalReason: reason,
		TenantID: tenantID, DeviceID: id,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// ReviewDevice records that somebody asked whether the device can come out.
func (r SupportRepo) ReviewDevice(ctx context.Context, scope authctx.TenantScope,
	deviceID, by string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(deviceID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).ReviewIcuDevice(ctx, sqlcgen.ReviewIcuDeviceParams{
		LastReviewedAt: stamp(at), LastReviewedBy: by,
		TenantID: tenantID, DeviceID: id,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Devices reads an episode's lines, tubes and drains.
func (r SupportRepo) Devices(ctx context.Context, scope authctx.TenantScope,
	episodeID string) ([]domain.InvasiveDevice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuDevices(ctx, sqlcgen.ListIcuDevicesParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.InvasiveDevice, 0, len(rows))
	for _, row := range rows {
		out = append(out, deviceFrom(row))
	}
	return out, nil
}

// DevicesInPeriod is unit-wide, for device days.
func (r SupportRepo) DevicesInPeriod(ctx context.Context, scope authctx.TenantScope,
	unitID string, from, to time.Time) ([]domain.InvasiveDevice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListIcuDevicesInPeriod(ctx,
		sqlcgen.ListIcuDevicesInPeriodParams{
			TenantID: tenantID, UnitID: unitID,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.InvasiveDevice, 0, len(rows))
	for _, row := range rows {
		out = append(out, deviceFrom(row))
	}
	return out, nil
}

func deviceFrom(row sqlcgen.IcuInvasiveDevice) domain.InvasiveDevice {
	return domain.InvasiveDevice{
		ID: row.DeviceID.String(), TenantID: row.TenantID.String(),
		EpisodeID: row.EpisodeID.String(),
		Kind:      row.Kind, Site: row.Site, Lumens: int(row.Lumens),
		InsertedAt: timeOf(row.InsertedAt), InsertedBy: row.InsertedBy,
		RemovedAt: timeOf(row.RemovedAt), RemovedBy: row.RemovedBy,
		RemovalReason:  row.RemovalReason,
		ReviewEvery:    time.Duration(row.ReviewEverySeconds) * time.Second,
		LastReviewedAt: timeOf(row.LastReviewedAt),
		LastReviewedBy: row.LastReviewedBy,
	}
}
