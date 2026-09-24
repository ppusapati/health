package postgres

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// -------------------------------------- utility metering (SRS-FAC-009)

var _ ports.MeterRepository = (*Repository)(nil)

func meterFrom(row sqlcgen.FacilitiesMeter) domain.Meter {
	return domain.Meter{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name,
		Utility: domain.Utility(row.Utility), Unit: row.Unit,
		FacilityID: uuidString(row.FacilityID),
		LocationID: uuidString(row.LocationID),
		AssetID:    uuidString(row.AssetID),
		Source:     domain.Source(row.Source), SourceRef: row.SourceRef,
		Cumulative: row.Cumulative, RegisterMax: int(row.RegisterMax),
		Active:    row.Active,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

func readingFrom(row sqlcgen.FacilitiesMeterReading) domain.Reading {
	return domain.Reading{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		MeterID: row.MeterID.String(), Value: int(row.Value),
		ReadAt: timeOf(row.ReadAt),
		Source: domain.Source(row.Source), SourceRef: row.SourceRef,
		RecordedBy: row.RecordedBy, RolledOver: row.RolledOver,
		Note: row.Note, CreatedAt: timeOf(row.CreatedAt),
	}
}

// InsertMeter implements ports.MeterRepository.
func (r *Repository) InsertMeter(ctx context.Context,
	scope authctx.TenantScope, m domain.Meter) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(m.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesMeter(ctx,
		sqlcgen.InsertFacilitiesMeterParams{
			ID: id, TenantID: tenantID, Code: m.Code, Name: m.Name,
			Utility: string(m.Utility), Unit: m.Unit,
			FacilityID: m.FacilityID, LocationID: m.LocationID,
			AssetID: m.AssetID,
			Source:  string(m.Source), SourceRef: m.SourceRef,
			Cumulative:  m.Cumulative,
			RegisterMax: int32(m.RegisterMax), Active: m.Active,
			CreatedAt: stamp(m.CreatedAt), CreatedBy: m.CreatedBy,
		})
	return uniqueViolation(err)
}

// Meter implements ports.MeterRepository.
func (r *Repository) Meter(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Meter, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Meter{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Meter{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesMeter(ctx,
		sqlcgen.GetFacilitiesMeterParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Meter{}, notFound()
	}
	if err != nil {
		return domain.Meter{}, err
	}
	return meterFrom(row), nil
}

// Meters implements ports.MeterRepository.
func (r *Repository) Meters(ctx context.Context, scope authctx.TenantScope,
	f ports.MeterFilter) ([]domain.Meter, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesMeters(ctx,
		sqlcgen.ListFacilitiesMetersParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			Utility: string(f.Utility), ActiveOnly: f.ActiveOnly,
			RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Meter, 0, len(found))
	for _, row := range found {
		out = append(out, meterFrom(row))
	}
	return out, nil
}

// InsertReading implements ports.MeterRepository.
func (r *Repository) InsertReading(ctx context.Context,
	scope authctx.TenantScope, reading domain.Reading) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(reading.ID)
	if err != nil {
		return err
	}
	meterID, err := parseID(reading.MeterID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesMeterReading(ctx,
		sqlcgen.InsertFacilitiesMeterReadingParams{
			ID: id, TenantID: tenantID, MeterID: meterID,
			Value: int32(reading.Value), ReadAt: stamp(reading.ReadAt),
			Source: string(reading.Source), SourceRef: reading.SourceRef,
			RecordedBy: reading.RecordedBy,
			RolledOver: reading.RolledOver, Note: reading.Note,
			CreatedAt: stamp(reading.CreatedAt),
		})
	return err
}

// Readings implements ports.MeterRepository.
func (r *Repository) Readings(ctx context.Context, scope authctx.TenantScope,
	meterID string, from, to time.Time, limit int32) (
	[]domain.Reading, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := parseID(meterID)
	if err != nil {
		return nil, err
	}
	windowFrom, windowTo := window(from, to)
	found, err := r.queries(ctx).ListFacilitiesMeterReadings(ctx,
		sqlcgen.ListFacilitiesMeterReadingsParams{
			TenantID: tenantID, MeterID: parsed,
			ReadFrom: stamp(windowFrom), ReadTo: stamp(windowTo),
			RowLimit: rows(limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Reading, 0, len(found))
	for _, row := range found {
		out = append(out, readingFrom(row))
	}
	return out, nil
}

// -------------------------------------- planned outages (SRS-FAC-004)

var _ ports.OutageRepository = (*Repository)(nil)

func outageFrom(row sqlcgen.FacilitiesOutage) domain.Outage {
	return domain.Outage{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		Reference:  row.Reference,
		FacilityID: uuidString(row.FacilityID),
		System:     domain.System(row.System),
		Title:      row.Title, Reason: row.Reason,
		PlannedFrom: timeOf(row.PlannedFrom),
		PlannedTo:   timeOf(row.PlannedTo),
		ActualFrom:  timeOf(row.ActualFrom),
		ActualTo:    timeOf(row.ActualTo),
		State:       domain.OutageState(row.State),
		RequestedBy: row.RequestedBy,
		RequestedAt: timeOf(row.RequestedAt),
		ApprovedBy:  row.ApprovedBy,
		ApprovedAt:  timeOf(row.ApprovedAt),
		PermitRef:   row.PermitRef, Contingency: row.Contingency,
		RestoredBy: row.RestoredBy, CancelReason: row.CancelReason,
		CreatedAt: timeOf(row.CreatedAt), Version: row.Version,
	}
}

func areaFrom(row sqlcgen.FacilitiesOutageArea) domain.OutageArea {
	return domain.OutageArea{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		OutageID:  row.OutageID.String(),
		OrgUnitID: uuidString(row.OrgUnitID),
		Name:      row.Name, Critical: row.Critical,
		OutageSystem:   domain.System(row.OutageSystem),
		OutageState:    domain.OutageState(row.OutageState),
		NotifiedAt:     timeOf(row.NotifiedAt),
		AcknowledgedAt: timeOf(row.AcknowledgedAt),
		AcknowledgedBy: row.AcknowledgedBy,
		Objection:      row.Objection,
		CreatedAt:      timeOf(row.CreatedAt), Version: row.Version,
	}
}

// InsertOutage implements ports.OutageRepository.
func (r *Repository) InsertOutage(ctx context.Context,
	scope authctx.TenantScope, o domain.Outage) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(o.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesOutage(ctx,
		sqlcgen.InsertFacilitiesOutageParams{
			ID: id, TenantID: tenantID, Reference: o.Reference,
			FacilityID: o.FacilityID, System: string(o.System),
			Title: o.Title, Reason: o.Reason,
			PlannedFrom: stamp(o.PlannedFrom),
			PlannedTo:   stamp(o.PlannedTo),
			State:       string(o.State),
			RequestedBy: o.RequestedBy,
			RequestedAt: stamp(o.RequestedAt),
			Contingency: o.Contingency,
			CreatedAt:   stamp(o.CreatedAt),
		})
	return uniqueViolation(err)
}

// Outage implements ports.OutageRepository.
func (r *Repository) Outage(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Outage, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Outage{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Outage{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesOutage(ctx,
		sqlcgen.GetFacilitiesOutageParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Outage{}, notFound()
	}
	if err != nil {
		return domain.Outage{}, err
	}
	return outageFrom(row), nil
}

// UpdateOutage implements ports.OutageRepository.
//
// Changing the state here rewrites every area row's copy of it through the
// composite foreign key, so the "one live shutdown per department" index sees
// the new state without a second write. That is why there is no method that
// sets an area's state directly: there would then be two ways for it to
// change, and one of them could disagree with the outage.
func (r *Repository) UpdateOutage(ctx context.Context,
	scope authctx.TenantScope, o domain.Outage,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(o.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesOutage(ctx,
		sqlcgen.UpdateFacilitiesOutageParams{
			State:      string(o.State),
			ApprovedBy: o.ApprovedBy,
			ApprovedAt: stampText(o.ApprovedAt),
			PermitRef:  o.PermitRef, Contingency: o.Contingency,
			ActualFrom: stampText(o.ActualFrom),
			ActualTo:   stampText(o.ActualTo),
			RestoredBy: o.RestoredBy, CancelReason: o.CancelReason,
			TenantID: tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return uniqueViolation(conflict(err))
	}
	return nil
}

// Outages implements ports.OutageRepository.
func (r *Repository) Outages(ctx context.Context, scope authctx.TenantScope,
	f ports.OutageFilter) ([]domain.Outage, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	found, err := r.queries(ctx).ListFacilitiesOutages(ctx,
		sqlcgen.ListFacilitiesOutagesParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			System: string(f.System), LiveOnly: f.LiveOnly,
			WindowFrom: stamp(from), WindowTo: stamp(to),
			RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Outage, 0, len(found))
	for _, row := range found {
		out = append(out, outageFrom(row))
	}
	return out, nil
}

// InsertArea implements ports.OutageRepository.
func (r *Repository) InsertArea(ctx context.Context,
	scope authctx.TenantScope, a domain.OutageArea) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}
	outageID, err := parseID(a.OutageID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesOutageArea(ctx,
		sqlcgen.InsertFacilitiesOutageAreaParams{
			ID: id, TenantID: tenantID, OutageID: outageID,
			OrgUnitID: a.OrgUnitID, Name: a.Name,
			Critical:     a.Critical,
			OutageSystem: string(a.OutageSystem),
			OutageState:  string(a.OutageState),
			CreatedAt:    stamp(a.CreatedAt),
		})
	return uniqueViolation(err)
}

// UpdateArea implements ports.OutageRepository.
//
// Only the notification columns. The area's copy of the outage's system and
// state is not writable from here at all: it follows the outage through the
// database or it does not change.
func (r *Repository) UpdateArea(ctx context.Context,
	scope authctx.TenantScope, a domain.OutageArea,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesOutageArea(ctx,
		sqlcgen.UpdateFacilitiesOutageAreaParams{
			NotifiedAt:     stampText(a.NotifiedAt),
			AcknowledgedAt: stampText(a.AcknowledgedAt),
			AcknowledgedBy: a.AcknowledgedBy,
			Objection:      a.Objection,
			TenantID:       tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// Areas implements ports.OutageRepository.
func (r *Repository) Areas(ctx context.Context, scope authctx.TenantScope,
	outageID string) ([]domain.OutageArea, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := parseID(outageID)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesOutageAreas(ctx,
		sqlcgen.ListFacilitiesOutageAreasParams{
			TenantID: tenantID, OutageID: parsed})
	if err != nil {
		return nil, err
	}
	out := make([]domain.OutageArea, 0, len(found))
	for _, row := range found {
		out = append(out, areaFrom(row))
	}
	return out, nil
}

// ---------------------------------------- SCADA alarms (SRS-FAC-005)

var _ ports.AlarmRepository = (*Repository)(nil)

func alarmFrom(row sqlcgen.FacilitiesAlarm) domain.Alarm {
	return domain.Alarm{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		GatewayID: row.GatewayID, PointRef: row.PointRef,
		ExternalID: row.ExternalID,
		AssetID:    uuidString(row.AssetID),
		FacilityID: uuidString(row.FacilityID),
		System:     domain.System(row.System),
		Severity:   domain.Severity(row.Severity),
		Message:    row.Message, Source: domain.Source(row.Source),
		RaisedAt:       timeOf(row.RaisedAt),
		ClearedAt:      timeOf(row.ClearedAt),
		State:          domain.AlarmState(row.State),
		AcknowledgedAt: timeOf(row.AcknowledgedAt),
		AcknowledgedBy: row.AcknowledgedBy,
		WorkOrderID:    uuidString(row.WorkOrderID),
		LinkedAt:       timeOf(row.LinkedAt), LinkedBy: row.LinkedBy,
		CreatedAt: timeOf(row.CreatedAt), Version: row.Version,
	}
}

func ruleFrom(row sqlcgen.FacilitiesAlarmRule) domain.AlarmRule {
	return domain.AlarmRule{
		TenantID:    row.TenantID.String(),
		FacilityID:  uuidString(row.FacilityID),
		System:      domain.System(row.System),
		MinSeverity: domain.Severity(row.MinSeverity),
		Priority:    domain.Priority(row.Priority),
		ClassCode:   row.ClassCode, OwnerTeam: row.OwnerTeam,
		Active: row.Active,
	}
}

// InsertAlarm implements ports.AlarmRepository.
func (r *Repository) InsertAlarm(ctx context.Context,
	scope authctx.TenantScope, a domain.Alarm) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesAlarm(ctx,
		sqlcgen.InsertFacilitiesAlarmParams{
			ID: id, TenantID: tenantID,
			GatewayID: a.GatewayID, PointRef: a.PointRef,
			ExternalID: a.ExternalID, AssetID: a.AssetID,
			FacilityID: a.FacilityID, System: string(a.System),
			Severity: string(a.Severity), Message: a.Message,
			Source:   string(a.Source),
			RaisedAt: stamp(a.RaisedAt), State: string(a.State),
			CreatedAt: stamp(a.CreatedAt),
		})
	return uniqueViolation(err)
}

// Alarm implements ports.AlarmRepository.
func (r *Repository) Alarm(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Alarm, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Alarm{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Alarm{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesAlarm(ctx,
		sqlcgen.GetFacilitiesAlarmParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Alarm{}, notFound()
	}
	if err != nil {
		return domain.Alarm{}, err
	}
	return alarmFrom(row), nil
}

// AlarmByEvent implements ports.AlarmRepository.
func (r *Repository) AlarmByEvent(ctx context.Context,
	scope authctx.TenantScope, gatewayID, externalID string) (
	domain.Alarm, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Alarm{}, false, err
	}
	row, err := r.queries(ctx).GetFacilitiesAlarmByEvent(ctx,
		sqlcgen.GetFacilitiesAlarmByEventParams{
			TenantID: tenantID, GatewayID: gatewayID,
			ExternalID: externalID})
	if isNoRows(err) {
		// A new event, not a failure.
		return domain.Alarm{}, false, nil
	}
	if err != nil {
		return domain.Alarm{}, false, err
	}
	return alarmFrom(row), true, nil
}

// UpdateAlarm implements ports.AlarmRepository.
//
// It writes the alarm's own state, its acknowledgement and its link. It does
// not touch the work order, and there is no call here that does: SRS-FAC-005
// asks that the two lifecycles stay distinct, and the way to guarantee that
// is that no single write reaches both.
func (r *Repository) UpdateAlarm(ctx context.Context,
	scope authctx.TenantScope, a domain.Alarm,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesAlarm(ctx,
		sqlcgen.UpdateFacilitiesAlarmParams{
			State:          string(a.State),
			ClearedAt:      stampText(a.ClearedAt),
			AcknowledgedAt: stampText(a.AcknowledgedAt),
			AcknowledgedBy: a.AcknowledgedBy,
			WorkOrderID:    a.WorkOrderID,
			LinkedAt:       stampText(a.LinkedAt),
			LinkedBy:       a.LinkedBy,
			TenantID:       tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// Alarms implements ports.AlarmRepository.
func (r *Repository) Alarms(ctx context.Context, scope authctx.TenantScope,
	f ports.AlarmFilter) ([]domain.Alarm, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	found, err := r.queries(ctx).ListFacilitiesAlarms(ctx,
		sqlcgen.ListFacilitiesAlarmsParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			System: string(f.System), State: string(f.State),
			UnansweredOnly: f.UnansweredOnly,
			RaisedFrom:     stamp(from), RaisedTo: stamp(to),
			RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Alarm, 0, len(found))
	for _, row := range found {
		out = append(out, alarmFrom(row))
	}
	return out, nil
}

// InsertAlarmRule implements ports.AlarmRepository.
func (r *Repository) InsertAlarmRule(ctx context.Context,
	scope authctx.TenantScope, id string, rule domain.AlarmRule,
	by string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := parseID(id)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesAlarmRule(ctx,
		sqlcgen.InsertFacilitiesAlarmRuleParams{
			ID: parsed, TenantID: tenantID,
			FacilityID: rule.FacilityID, System: string(rule.System),
			MinSeverity: string(rule.MinSeverity),
			Priority:    string(rule.Priority),
			ClassCode:   rule.ClassCode, OwnerTeam: rule.OwnerTeam,
			Active:    rule.Active,
			CreatedAt: stamp(at), CreatedBy: by,
		})
	return err
}

// AlarmRules implements ports.AlarmRepository.
func (r *Repository) AlarmRules(ctx context.Context,
	scope authctx.TenantScope, system domain.System) (
	[]domain.AlarmRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesAlarmRules(ctx,
		sqlcgen.ListFacilitiesAlarmRulesParams{
			TenantID: tenantID, System: string(system)})
	if err != nil {
		return nil, err
	}
	out := make([]domain.AlarmRule, 0, len(found))
	for _, row := range found {
		out = append(out, ruleFrom(row))
	}
	return out, nil
}

// ------------------------------ fire and life safety (SRS-FAC-008)

var _ ports.DeficiencyRepository = (*Repository)(nil)

func deficiencyFrom(row sqlcgen.FacilitiesDeficiency) domain.Deficiency {
	return domain.Deficiency{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		TaskID:       uuidString(row.TaskID),
		AssetID:      uuidString(row.AssetID),
		FacilityID:   uuidString(row.FacilityID),
		LocationID:   uuidString(row.LocationID),
		LocationNote: row.LocationNote,
		System:       domain.System(row.System),
		Severity:     domain.Severity(row.Severity),
		Finding:      row.Finding, Standard: row.Standard,
		State:    domain.DeficiencyState(row.State),
		RaisedAt: timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		DueAt:          timeOf(row.DueAt),
		WorkOrderID:    uuidString(row.WorkOrderID),
		MitigationNote: row.MitigationNote,
		MitigatedAt:    timeOf(row.MitigatedAt),
		MitigatedBy:    row.MitigatedBy,
		ClosedAt:       timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureEvidenceRef: row.ClosureEvidenceRef,
		CreatedAt:          timeOf(row.CreatedAt), Version: row.Version,
	}
}

// InsertDeficiency implements ports.DeficiencyRepository.
func (r *Repository) InsertDeficiency(ctx context.Context,
	scope authctx.TenantScope, d domain.Deficiency) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(d.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesDeficiency(ctx,
		sqlcgen.InsertFacilitiesDeficiencyParams{
			ID: id, TenantID: tenantID,
			TaskID: d.TaskID, AssetID: d.AssetID,
			FacilityID: d.FacilityID, LocationID: d.LocationID,
			LocationNote: d.LocationNote,
			System:       string(d.System),
			Severity:     string(d.Severity),
			Finding:      d.Finding, Standard: d.Standard,
			State:    string(d.State),
			RaisedAt: stamp(d.RaisedAt), RaisedBy: d.RaisedBy,
			DueAt:       stampText(d.DueAt),
			WorkOrderID: d.WorkOrderID,
			CreatedAt:   stamp(d.CreatedAt),
		})
	return err
}

// Deficiency implements ports.DeficiencyRepository.
func (r *Repository) Deficiency(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Deficiency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Deficiency{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Deficiency{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesDeficiency(ctx,
		sqlcgen.GetFacilitiesDeficiencyParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Deficiency{}, notFound()
	}
	if err != nil {
		return domain.Deficiency{}, err
	}
	return deficiencyFrom(row), nil
}

// UpdateDeficiency implements ports.DeficiencyRepository.
func (r *Repository) UpdateDeficiency(ctx context.Context,
	scope authctx.TenantScope, d domain.Deficiency,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(d.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesDeficiency(ctx,
		sqlcgen.UpdateFacilitiesDeficiencyParams{
			State:              string(d.State),
			MitigationNote:     d.MitigationNote,
			MitigatedAt:        stampText(d.MitigatedAt),
			MitigatedBy:        d.MitigatedBy,
			ClosedAt:           stampText(d.ClosedAt),
			ClosedBy:           d.ClosedBy,
			ClosureEvidenceRef: d.ClosureEvidenceRef,
			TenantID:           tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// Deficiencies implements ports.DeficiencyRepository.
func (r *Repository) Deficiencies(ctx context.Context,
	scope authctx.TenantScope, f ports.DeficiencyFilter) (
	[]domain.Deficiency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesDeficiencies(ctx,
		sqlcgen.ListFacilitiesDeficienciesParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			TaskID: f.TaskID, Severity: string(f.Severity),
			OpenOnly: f.OpenOnly, RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Deficiency, 0, len(found))
	for _, row := range found {
		out = append(out, deficiencyFrom(row))
	}
	return out, nil
}

// ----------------------------------- contractor visits (SRS-FAC-011)

var _ ports.VisitRepository = (*Repository)(nil)

func visitFrom(row sqlcgen.FacilitiesVendorVisit) domain.Visit {
	return domain.Visit{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		VendorName: row.VendorName, VendorRef: row.VendorRef,
		ContactName: row.ContactName, Technicians: row.Technicians,
		FacilityID:         uuidString(row.FacilityID),
		WorkOrderID:        uuidString(row.WorkOrderID),
		AssetID:            uuidString(row.AssetID),
		TaskID:             uuidString(row.TaskID),
		WorkRequiresPermit: row.WorkRequiresPermit,
		InductionRef:       row.InductionRef,
		Purpose:            row.Purpose,
		State:              domain.VisitState(row.State),
		SignedInAt:         timeOf(row.SignedInAt),
		SignedInBy:         row.SignedInBy,
		SignedOutAt:        timeOf(row.SignedOutAt),
		SignedOutBy:        row.SignedOutBy,
		ServiceReportRef:   row.ServiceReportRef,
		ReportSummary:      row.ReportSummary,
		PartsUsed:          row.PartsUsed,
		FollowUp:           row.FollowUp,
		CreatedAt:          timeOf(row.CreatedAt), Version: row.Version,
	}
}

// InsertVisit implements ports.VisitRepository.
func (r *Repository) InsertVisit(ctx context.Context,
	scope authctx.TenantScope, v domain.Visit) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(v.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesVendorVisit(ctx,
		sqlcgen.InsertFacilitiesVendorVisitParams{
			ID: id, TenantID: tenantID,
			VendorName: v.VendorName, VendorRef: v.VendorRef,
			ContactName: v.ContactName,
			Technicians: texts(v.Technicians),
			FacilityID:  v.FacilityID,
			WorkOrderID: v.WorkOrderID, AssetID: v.AssetID,
			TaskID:             v.TaskID,
			WorkRequiresPermit: v.WorkRequiresPermit,
			InductionRef:       v.InductionRef,
			Purpose:            v.Purpose, State: string(v.State),
			SignedInAt: stamp(v.SignedInAt),
			SignedInBy: v.SignedInBy,
			CreatedAt:  stamp(v.CreatedAt),
		})
	return err
}

// Visit implements ports.VisitRepository.
func (r *Repository) Visit(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Visit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Visit{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Visit{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesVendorVisit(ctx,
		sqlcgen.GetFacilitiesVendorVisitParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Visit{}, notFound()
	}
	if err != nil {
		return domain.Visit{}, err
	}
	return visitFrom(row), nil
}

// UpdateVisit implements ports.VisitRepository.
func (r *Repository) UpdateVisit(ctx context.Context,
	scope authctx.TenantScope, v domain.Visit,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(v.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesVendorVisit(ctx,
		sqlcgen.UpdateFacilitiesVendorVisitParams{
			State:            string(v.State),
			SignedOutAt:      stampText(v.SignedOutAt),
			SignedOutBy:      v.SignedOutBy,
			ServiceReportRef: v.ServiceReportRef,
			ReportSummary:    v.ReportSummary,
			PartsUsed:        texts(v.PartsUsed),
			FollowUp:         v.FollowUp,
			TenantID:         tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// Visits implements ports.VisitRepository.
func (r *Repository) Visits(ctx context.Context, scope authctx.TenantScope,
	f ports.VisitFilter) ([]domain.Visit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesVendorVisits(ctx,
		sqlcgen.ListFacilitiesVendorVisitsParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			WorkOrderID: f.WorkOrderID, AssetID: f.AssetID,
			OnSiteOnly: f.OnSiteOnly, RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Visit, 0, len(found))
	for _, row := range found {
		out = append(out, visitFrom(row))
	}
	return out, nil
}
