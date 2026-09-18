package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/anaesthesia/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// RecordRepo implements ports.RecordRepository.
type RecordRepo struct{ *Repository }

var _ ports.RecordRepository = RecordRepo{}

// InsertRecord opens an intraoperative record.
func (r RecordRepo) InsertRecord(ctx context.Context, scope authctx.TenantScope,
	rec domain.Record) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	recordID, err := uuid.Parse(rec.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(rec.CaseID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(rec.PatientID)
	if err != nil {
		return notFound()
	}
	encounterID, err := optionalUUID(rec.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAnaesthesiaRecord(ctx,
		sqlcgen.InsertAnaesthesiaRecordParams{
			RecordID: recordID, TenantID: tenantID, CaseID: caseID,
			EncounterID: encounterID, PatientID: patientID,
			Technique: string(rec.Technique), Status: string(rec.Status),
			StartedAt: stamp(rec.StartedAt), StartedBy: rec.StartedBy,
			EndedAt: stamp(rec.EndedAt),
			Origin:  string(rec.Origin), ImportNote: rec.ImportNote,
			ImportedAt: stamp(rec.ImportedAt), ImportedBy: rec.ImportedBy,
		})
}

// Record reads one intraoperative record.
func (r RecordRepo) Record(ctx context.Context, scope authctx.TenantScope,
	recordID string) (domain.Record, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Record{}, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return domain.Record{}, notFound()
	}

	row, err := r.queries(ctx).GetAnaesthesiaRecord(ctx,
		sqlcgen.GetAnaesthesiaRecordParams{TenantID: tenantID, RecordID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Record{}, notFound()
	}
	if err != nil {
		return domain.Record{}, err
	}
	return recordFrom(row), nil
}

// RecordForCase reads the record for an operation, if one has been started.
func (r RecordRepo) RecordForCase(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.Record, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Record{}, false, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Record{}, false, notFound()
	}

	row, err := r.queries(ctx).GetAnaesthesiaRecordForCase(ctx,
		sqlcgen.GetAnaesthesiaRecordForCaseParams{TenantID: tenantID, CaseID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Record{}, false, nil
	}
	if err != nil {
		return domain.Record{}, false, err
	}
	return recordFrom(row), true, nil
}

// UpdateStatus moves the record through recovery and closure.
func (r RecordRepo) UpdateStatus(ctx context.Context, scope authctx.TenantScope,
	recordID string, status domain.RecordStatus, endedAt time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpdateAnaesthesiaRecordStatus(ctx,
		sqlcgen.UpdateAnaesthesiaRecordStatusParams{
			TenantID: tenantID, RecordID: id,
			Status: string(status), EndedAt: stamp(endedAt),
		})
}

// PatientRecords lists a patient's anaesthetics, most recent first.
func (r RecordRepo) PatientRecords(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) ([]domain.Record, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientAnaesthesiaRecords(ctx,
		sqlcgen.ListPatientAnaesthesiaRecordsParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Record, 0, len(rows))
	for _, row := range rows {
		out = append(out, recordFrom(row))
	}
	return out, nil
}

func recordFrom(row sqlcgen.AnaesthesiaRecord) domain.Record {
	return domain.Record{
		ID: row.RecordID.String(), TenantID: row.TenantID.String(),
		CaseID:      row.CaseID.String(),
		EncounterID: uuidOrEmpty(row.EncounterID),
		PatientID:   row.PatientID.String(),
		Technique:   domain.Technique(row.Technique),
		Status:      domain.RecordStatus(row.Status),
		StartedAt:   timeOf(row.StartedAt), StartedBy: row.StartedBy,
		EndedAt: timeOf(row.EndedAt),
		Origin:  domain.EntrySource(row.Origin), ImportNote: row.ImportNote,
		ImportedAt: timeOf(row.ImportedAt), ImportedBy: row.ImportedBy,
	}
}

// InsertVital charts one intraoperative value.
func (r RecordRepo) InsertVital(ctx context.Context, scope authctx.TenantScope,
	v domain.VitalEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	vitalID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(v.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAnaesthesiaVital(ctx,
		sqlcgen.InsertAnaesthesiaVitalParams{
			VitalID: vitalID, TenantID: tenantID, RecordID: recordID,
			Code: v.Code, Display: v.Display, Value: v.Value, Unit: v.Unit,
			Source: string(v.Source), DeviceID: v.Device.DeviceID,
			DeviceModel: v.Device.Model, DeviceConnected: v.Device.Connected,
			DeviceMeasuredAt: stamp(v.Device.MeasuredAt),
			ObservedAt:       stamp(v.ObservedAt), RecordedAt: stamp(v.RecordedAt),
			RecordedBy: v.RecordedBy,
		})
}

// Vitals reads the chart. An empty code returns every series.
func (r RecordRepo) Vitals(ctx context.Context, scope authctx.TenantScope,
	recordID, code string) ([]domain.VitalEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaVitals(ctx,
		sqlcgen.ListAnaesthesiaVitalsParams{
			TenantID: tenantID, RecordID: id, Code: code,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.VitalEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.VitalEntry{
			ID: row.VitalID.String(), TenantID: row.TenantID.String(),
			RecordID: row.RecordID.String(),
			Code:     row.Code, Display: row.Display, Value: row.Value, Unit: row.Unit,
			Source: domain.EntrySource(row.Source),
			Device: domain.DeviceLink{
				DeviceID: row.DeviceID, Model: row.DeviceModel,
				Connected: row.DeviceConnected,
				// The device's own clock, which is what makes a reading
				// stale: a value that arrives now carrying a measurement
				// time from ten minutes ago is ten minutes old.
				MeasuredAt: timeOf(row.DeviceMeasuredAt),
			},
			ObservedAt: timeOf(row.ObservedAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// InsertDrug charts one drug or infusion.
func (r RecordRepo) InsertDrug(ctx context.Context, scope authctx.TenantScope,
	d domain.DrugEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	drugID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(d.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAnaesthesiaDrug(ctx,
		sqlcgen.InsertAnaesthesiaDrugParams{
			DrugID: drugID, TenantID: tenantID, RecordID: recordID,
			DrugCode: d.DrugCode, DrugDisplay: d.DrugDisplay,
			Route: string(d.Route), Dose: d.Dose, DoseUnit: d.DoseUnit,
			ConcentrationAmount: d.ConcentrationAmount,
			ConcentrationUnit:   d.ConcentrationUnit,
			ConcentrationVolume: d.ConcentrationVolume,
			RateMlPerHour:       d.RateMLPerHour,
			Infusion:            d.Infusion, StoppedAt: stamp(d.StoppedAt),
			Source: string(d.Source), DeviceID: d.Device.DeviceID,
			DeviceConnected:  d.Device.Connected,
			DeviceMeasuredAt: stamp(d.Device.MeasuredAt),
			GivenAt:          stamp(d.GivenAt), RecordedAt: stamp(d.RecordedAt),
			RecordedBy: d.RecordedBy, Note: d.Note,
		})
}

// Drugs reads the drug chart.
func (r RecordRepo) Drugs(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.DrugEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaDrugs(ctx,
		sqlcgen.ListAnaesthesiaDrugsParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.DrugEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.DrugEntry{
			ID: row.DrugID.String(), TenantID: row.TenantID.String(),
			RecordID: row.RecordID.String(),
			DrugCode: row.DrugCode, DrugDisplay: row.DrugDisplay,
			Route: domain.DrugRoute(row.Route),
			Dose:  row.Dose, DoseUnit: row.DoseUnit,
			ConcentrationAmount: row.ConcentrationAmount,
			ConcentrationUnit:   row.ConcentrationUnit,
			ConcentrationVolume: row.ConcentrationVolume,
			RateMLPerHour:       row.RateMlPerHour,
			Infusion:            row.Infusion, StoppedAt: timeOf(row.StoppedAt),
			Source: domain.EntrySource(row.Source),
			Device: domain.DeviceLink{
				DeviceID: row.DeviceID, Connected: row.DeviceConnected,
				MeasuredAt: timeOf(row.DeviceMeasuredAt),
			},
			GivenAt: timeOf(row.GivenAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy, Note: row.Note,
		})
	}
	return out, nil
}

// StopInfusion records the time a running infusion was stopped.
//
// False where it was already stopped: two people stopping the same pump is
// ordinary at the end of a case, and the first stop time is the true one.
func (r RecordRepo) StopInfusion(ctx context.Context, scope authctx.TenantScope,
	drugID string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(drugID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).StopAnaesthesiaInfusion(ctx,
		sqlcgen.StopAnaesthesiaInfusionParams{
			TenantID: tenantID, DrugID: id, StoppedAt: stamp(at),
		})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// InsertAirwayEvent records one airway attempt.
func (r RecordRepo) InsertAirwayEvent(ctx context.Context,
	scope authctx.TenantScope, e domain.AirwayEvent) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	airwayID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(e.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAnaesthesiaAirwayEvent(ctx,
		sqlcgen.InsertAnaesthesiaAirwayEventParams{
			AirwayID: airwayID, TenantID: tenantID, RecordID: recordID,
			Device: e.Device, Attempt: int32(e.Attempt), Grade: string(e.Grade),
			Successful: e.Successful, Difficulty: e.Difficulty,
			Complications: strings0(e.Complications),
			Adjuncts:      strings0(e.Adjuncts),
			OccurredAt:    stamp(e.OccurredAt), RecordedBy: e.RecordedBy,
		})
}

// AirwayEvents reads one record's airway attempts, in order.
func (r RecordRepo) AirwayEvents(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.AirwayEvent, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaAirwayEvents(ctx,
		sqlcgen.ListAnaesthesiaAirwayEventsParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	return airwayEventsFrom(rows), nil
}

// PatientAirwayEvents reads the difficult-airway history across admissions.
func (r RecordRepo) PatientAirwayEvents(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.AirwayEvent, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientAirwayEvents(ctx,
		sqlcgen.ListPatientAirwayEventsParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return airwayEventsFrom(rows), nil
}

func airwayEventsFrom(rows []sqlcgen.AnaesthesiaAirwayEvent) []domain.AirwayEvent {
	out := make([]domain.AirwayEvent, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.AirwayEvent{
			ID: row.AirwayID.String(), TenantID: row.TenantID.String(),
			RecordID: row.RecordID.String(),
			Device:   row.Device, Attempt: int(row.Attempt),
			Grade: domain.AirwayGrade(row.Grade), Successful: row.Successful,
			Difficulty: row.Difficulty, Complications: row.Complications,
			Adjuncts:   row.Adjuncts,
			OccurredAt: timeOf(row.OccurredAt), RecordedBy: row.RecordedBy,
		})
	}
	return out
}

// InsertFluid records one fluid in or out.
func (r RecordRepo) InsertFluid(ctx context.Context, scope authctx.TenantScope,
	f domain.FluidEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	fluidID, err := uuid.Parse(f.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(f.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAnaesthesiaFluid(ctx,
		sqlcgen.InsertAnaesthesiaFluidParams{
			FluidID: fluidID, TenantID: tenantID, RecordID: recordID,
			Direction: string(f.Direction), Kind: f.Kind, Label: f.Label,
			VolumeMl: f.VolumeML, ProductID: f.ProductID,
			OccurredAt: stamp(f.OccurredAt), RecordedAt: stamp(f.RecordedAt),
			RecordedBy: f.RecordedBy,
		})
}

// Fluids reads the fluid chart.
func (r RecordRepo) Fluids(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.FluidEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaFluids(ctx,
		sqlcgen.ListAnaesthesiaFluidsParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.FluidEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.FluidEntry{
			ID: row.FluidID.String(), TenantID: row.TenantID.String(),
			RecordID:  row.RecordID.String(),
			Direction: domain.FluidDirection(row.Direction),
			Kind:      row.Kind, Label: row.Label, VolumeML: row.VolumeMl,
			ProductID:  row.ProductID,
			OccurredAt: timeOf(row.OccurredAt), RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// InsertHandover records the theatre-to-recovery handover.
func (r RecordRepo) InsertHandover(ctx context.Context, scope authctx.TenantScope,
	h domain.Handover) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	handoverID, err := uuid.Parse(h.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(h.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAnaesthesiaHandover(ctx,
		sqlcgen.InsertAnaesthesiaHandoverParams{
			HandoverID: handoverID, TenantID: tenantID, RecordID: recordID,
			FromClinician: h.FromClinician, ToClinician: h.ToClinician,
			Summary: h.Summary, Concerns: strings0(h.Concerns),
			Instructions:   strings0(h.Instructions),
			AnalgesiaGiven: strings0(h.AnalgesiaGiven),
			// Recovery has to know what is already on board before giving
			// more, and an antiemetic given in theatre is the commonest thing
			// repeated in PACU.
			AntiemeticGiven: strings0(h.AntiemeticGiven),
			HandedOverAt:    stamp(h.HandedOverAt),
		})
}

// Handovers reads a record's handovers, oldest first.
func (r RecordRepo) Handovers(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.Handover, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaHandovers(ctx,
		sqlcgen.ListAnaesthesiaHandoversParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Handover, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Handover{
			ID: row.HandoverID.String(), TenantID: row.TenantID.String(),
			RecordID:      row.RecordID.String(),
			FromClinician: row.FromClinician, ToClinician: row.ToClinician,
			Summary: row.Summary, Concerns: row.Concerns,
			Instructions:    row.Instructions,
			AnalgesiaGiven:  row.AnalgesiaGiven,
			AntiemeticGiven: row.AntiemeticGiven,
			HandedOverAt:    timeOf(row.HandedOverAt),
		})
	}
	return out, nil
}
