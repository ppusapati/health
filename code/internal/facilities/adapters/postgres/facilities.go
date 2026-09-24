package postgres

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ------------------------------------------------------ assets (SRS-FAC-001)

var _ ports.AssetRepository = (*Repository)(nil)

func assetFrom(row sqlcgen.FacilitiesAsset) domain.Asset {
	return domain.Asset{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		Tag: row.Tag, Name: row.Name,
		System:       domain.System(row.System),
		Criticality:  domain.Criticality(row.Criticality),
		ParentID:     uuidString(row.ParentID),
		FacilityID:   uuidString(row.FacilityID),
		LocationID:   uuidString(row.LocationID),
		LocationNote: row.LocationNote,
		Status:       domain.AssetStatus(row.Status),
		StatusReason: row.StatusReason,
		StatusAt:     timeOf(row.StatusAt),
		Manufacturer: row.Manufacturer, Model: row.Model,
		SerialNumber:   row.SerialNumber,
		CommissionedAt: timeOf(row.CommissionedAt),
		RuntimeHours:   int(row.RuntimeHours),
		RuntimeAt:      timeOf(row.RuntimeAt),
		CreatedAt:      timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// InsertAsset implements ports.AssetRepository.
func (r *Repository) InsertAsset(ctx context.Context,
	scope authctx.TenantScope, a domain.Asset) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}

	_, err = r.queries(ctx).InsertFacilitiesAsset(ctx,
		sqlcgen.InsertFacilitiesAssetParams{
			ID: id, TenantID: tenantID,
			Tag: a.Tag, Name: a.Name,
			System:      string(a.System),
			Criticality: string(a.Criticality),
			ParentID:    a.ParentID, FacilityID: a.FacilityID,
			LocationID: a.LocationID, LocationNote: a.LocationNote,
			Status: string(a.Status), StatusReason: a.StatusReason,
			StatusAt:     stamp(a.StatusAt),
			Manufacturer: a.Manufacturer, Model: a.Model,
			SerialNumber:   a.SerialNumber,
			CommissionedAt: stampText(a.CommissionedAt),
			CreatedAt:      stamp(a.CreatedAt), CreatedBy: a.CreatedBy,
		})
	return uniqueViolation(err)
}

// Asset implements ports.AssetRepository.
func (r *Repository) Asset(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Asset{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Asset{}, err
	}

	row, err := r.queries(ctx).GetFacilitiesAsset(ctx,
		sqlcgen.GetFacilitiesAssetParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Asset{}, notFound()
	}
	if err != nil {
		return domain.Asset{}, err
	}
	return assetFrom(row), nil
}

// AssetByTag implements ports.AssetRepository.
func (r *Repository) AssetByTag(ctx context.Context,
	scope authctx.TenantScope, tag string) (domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Asset{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesAssetByTag(ctx,
		sqlcgen.GetFacilitiesAssetByTagParams{
			TenantID: tenantID, Tag: tag})
	if isNoRows(err) {
		return domain.Asset{}, notFound()
	}
	if err != nil {
		return domain.Asset{}, err
	}
	return assetFrom(row), nil
}

// UpdateAssetStatus implements ports.AssetRepository.
func (r *Repository) UpdateAssetStatus(ctx context.Context,
	scope authctx.TenantScope, a domain.Asset, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(a.ID)
	if err != nil {
		return err
	}

	_, err = r.queries(ctx).SetFacilitiesAssetStatus(ctx,
		sqlcgen.SetFacilitiesAssetStatusParams{
			Status: string(a.Status), StatusReason: a.StatusReason,
			StatusAt: stamp(a.StatusAt),
			TenantID: tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// UpdateAssetRuntime implements ports.AssetRepository.
//
// The asset's counter is derived from the readings rather than typed, so it
// cannot disagree with them.
func (r *Repository) UpdateAssetRuntime(ctx context.Context,
	scope authctx.TenantScope, id string, hours int, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := parseID(id)
	if err != nil {
		return err
	}

	current, err := r.queries(ctx).GetFacilitiesAsset(ctx,
		sqlcgen.GetFacilitiesAssetParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return notFound()
	}
	if err != nil {
		return err
	}

	_, err = r.queries(ctx).SetFacilitiesAssetRuntime(ctx,
		sqlcgen.SetFacilitiesAssetRuntimeParams{
			RuntimeHours: int32(hours), RuntimeAt: stamp(at),
			TenantID: tenantID, ID: parsed,
			ExpectedVersion: current.Version,
		})
	return conflict(err)
}

// Assets implements ports.AssetRepository.
func (r *Repository) Assets(ctx context.Context, scope authctx.TenantScope,
	f ports.AssetFilter) ([]domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesAssets(ctx,
		sqlcgen.ListFacilitiesAssetsParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			System: string(f.System), Status: string(f.Status),
			ParentID: f.ParentID, RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Asset, 0, len(found))
	for _, row := range found {
		out = append(out, assetFrom(row))
	}
	return out, nil
}

// ------------------------------------------------ work classes (SRS-FAC-010)

var _ ports.WorkClassRepository = (*Repository)(nil)

func classFrom(row sqlcgen.FacilitiesWorkClass) domain.WorkClass {
	return domain.WorkClass{
		TenantID: row.TenantID.String(), Code: row.Code, Name: row.Name,
		RequiresPermit: row.RequiresPermit,
		RequiresLOTO:   row.RequiresLoto,
		Active:         row.Active, Note: row.Note,
	}
}

// UpsertWorkClass implements ports.WorkClassRepository.
//
// An upsert rather than an insert because the flags are configuration a
// hospital revises, usually after an incident. The composite foreign key on
// work_order cascades the revision onto every order of the class, which is
// how the copies stay honest — and why an update that would leave a closed
// order without its permit fails here rather than silently succeeding.
func (r *Repository) UpsertWorkClass(ctx context.Context,
	scope authctx.TenantScope, c domain.WorkClass) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpsertFacilitiesWorkClass(ctx,
		sqlcgen.UpsertFacilitiesWorkClassParams{
			TenantID: tenantID, Code: c.Code, Name: c.Name,
			RequiresPermit: c.RequiresPermit,
			RequiresLoto:   c.RequiresLOTO,
			Active:         c.Active, Note: c.Note,
		})
	return err
}

// WorkClass implements ports.WorkClassRepository.
func (r *Repository) WorkClass(ctx context.Context,
	scope authctx.TenantScope, code string) (domain.WorkClass, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.WorkClass{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesWorkClass(ctx,
		sqlcgen.GetFacilitiesWorkClassParams{
			TenantID: tenantID, Code: code})
	if isNoRows(err) {
		return domain.WorkClass{}, notFound()
	}
	if err != nil {
		return domain.WorkClass{}, err
	}
	return classFrom(row), nil
}

// WorkClasses implements ports.WorkClassRepository.
func (r *Repository) WorkClasses(ctx context.Context,
	scope authctx.TenantScope) ([]domain.WorkClass, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesWorkClasses(ctx, tenantID)
	if err != nil {
		return nil, err
	}
	out := make([]domain.WorkClass, 0, len(found))
	for _, row := range found {
		out = append(out, classFrom(row))
	}
	return out, nil
}

// ------------------------------------------------- work orders (SRS-FAC-002)

var _ ports.WorkOrderRepository = (*Repository)(nil)

func workOrderFrom(row sqlcgen.FacilitiesWorkOrder) domain.WorkOrder {
	return domain.WorkOrder{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		Number:       row.Number,
		FacilityID:   uuidString(row.FacilityID),
		AssetID:      uuidString(row.AssetID),
		System:       domain.System(row.System),
		LocationID:   uuidString(row.LocationID),
		LocationNote: row.LocationNote,
		Fault:        row.Fault, Impact: row.Impact,
		Priority:            domain.Priority(row.Priority),
		ClassCode:           row.ClassCode,
		ClassRequiresPermit: row.ClassRequiresPermit,
		ClassRequiresLOTO:   row.ClassRequiresLoto,
		OwnerTeam:           row.OwnerTeam,
		OwnerUserID:         row.OwnerUserID,
		State:               domain.WorkState(row.State),
		RaisedAt:            timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		RespondBy:   timeOf(row.RespondBy),
		ResolveBy:   timeOf(row.ResolveBy),
		RespondedAt: timeOf(row.RespondedAt),
		StartedAt:   timeOf(row.StartedAt),
		ResolvedAt:  timeOf(row.ResolvedAt),
		ClosedAt:    timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		PermitRef: row.PermitRef, PermitIssuedBy: row.PermitIssuedBy,
		LOTORef: row.LotoRef, LOTOAppliedBy: row.LotoAppliedBy,
		CompletionNote:  row.CompletionNote,
		RootCause:       row.RootCause,
		DowntimeMinutes: int(row.DowntimeMinutes),
		HoldReason:      row.HoldReason,
		CancelReason:    row.CancelReason,
		CreatedAt:       timeOf(row.CreatedAt), Version: row.Version,
	}
}

// InsertWorkOrder implements ports.WorkOrderRepository.
func (r *Repository) InsertWorkOrder(ctx context.Context,
	scope authctx.TenantScope, w domain.WorkOrder) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(w.ID)
	if err != nil {
		return err
	}

	_, err = r.queries(ctx).InsertFacilitiesWorkOrder(ctx,
		sqlcgen.InsertFacilitiesWorkOrderParams{
			ID: id, TenantID: tenantID, Number: w.Number,
			FacilityID: w.FacilityID, AssetID: w.AssetID,
			System:     string(w.System),
			LocationID: w.LocationID, LocationNote: w.LocationNote,
			Fault: w.Fault, Impact: w.Impact,
			Priority:            string(w.Priority),
			ClassCode:           w.ClassCode,
			ClassRequiresPermit: w.ClassRequiresPermit,
			ClassRequiresLoto:   w.ClassRequiresLOTO,
			OwnerTeam:           w.OwnerTeam,
			OwnerUserID:         w.OwnerUserID,
			State:               string(w.State),
			RaisedAt:            stamp(w.RaisedAt), RaisedBy: w.RaisedBy,
			RespondBy: stamp(w.RespondBy),
			ResolveBy: stamp(w.ResolveBy),
			CreatedAt: stamp(w.CreatedAt),
		})
	return uniqueViolation(err)
}

// WorkOrder implements ports.WorkOrderRepository.
func (r *Repository) WorkOrder(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.WorkOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesWorkOrder(ctx,
		sqlcgen.GetFacilitiesWorkOrderParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.WorkOrder{}, notFound()
	}
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return workOrderFrom(row), nil
}

// UpdateWorkOrder implements ports.WorkOrderRepository.
func (r *Repository) UpdateWorkOrder(ctx context.Context,
	scope authctx.TenantScope, w domain.WorkOrder,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(w.ID)
	if err != nil {
		return err
	}

	_, err = r.queries(ctx).UpdateFacilitiesWorkOrder(ctx,
		sqlcgen.UpdateFacilitiesWorkOrderParams{
			State:     string(w.State),
			OwnerTeam: w.OwnerTeam, OwnerUserID: w.OwnerUserID,
			RespondedAt: stampText(w.RespondedAt),
			StartedAt:   stampText(w.StartedAt),
			ResolvedAt:  stampText(w.ResolvedAt),
			ClosedAt:    stampText(w.ClosedAt), ClosedBy: w.ClosedBy,
			PermitRef: w.PermitRef, PermitIssuedBy: w.PermitIssuedBy,
			LotoRef: w.LOTORef, LotoAppliedBy: w.LOTOAppliedBy,
			CompletionNote:  w.CompletionNote,
			RootCause:       w.RootCause,
			DowntimeMinutes: int32(w.DowntimeMinutes),
			HoldReason:      w.HoldReason,
			CancelReason:    w.CancelReason,
			TenantID:        tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// WorkOrders implements ports.WorkOrderRepository.
func (r *Repository) WorkOrders(ctx context.Context,
	scope authctx.TenantScope, f ports.WorkOrderFilter) (
	[]domain.WorkOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	found, err := r.queries(ctx).ListFacilitiesWorkOrders(ctx,
		sqlcgen.ListFacilitiesWorkOrdersParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			AssetID: f.AssetID, System: string(f.System),
			State: string(f.State), OpenOnly: f.OpenOnly,
			RaisedFrom: stamp(from), RaisedTo: stamp(to),
			RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.WorkOrder, 0, len(found))
	for _, row := range found {
		out = append(out, workOrderFrom(row))
	}
	return out, nil
}

// ------------------------------------- maintenance (SRS-FAC-003/007)

var _ ports.MaintenanceRepository = (*Repository)(nil)

func scheduleFrom(row sqlcgen.FacilitiesSchedule) domain.Schedule {
	return domain.Schedule{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		AssetID:              uuidString(row.AssetID),
		FacilityID:           uuidString(row.FacilityID),
		Title:                row.Title,
		Kind:                 domain.MaintenanceKind(row.Kind),
		Trigger:              domain.Trigger(row.TriggerKind),
		IntervalDays:         int(row.IntervalDays),
		IntervalRuntimeHours: int(row.IntervalRuntimeHours),
		Authority:            row.Authority,
		RequiresEvidence:     row.RequiresEvidence,
		WorkClassCode:        row.WorkClassCode,
		GraceDays:            int(row.GraceDays),
		Active:               row.Active,
		CreatedAt:            timeOf(row.CreatedAt),
		CreatedBy:            row.CreatedBy, Version: row.Version,
	}
}

func taskFrom(row sqlcgen.FacilitiesTask) domain.Task {
	return domain.Task{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		ScheduleID:               row.ScheduleID.String(),
		AssetID:                  uuidString(row.AssetID),
		FacilityID:               uuidString(row.FacilityID),
		Title:                    row.Title,
		ScheduleKind:             domain.MaintenanceKind(row.ScheduleKind),
		ScheduleRequiresEvidence: row.ScheduleRequiresEvidence,
		DueAt:                    timeOf(row.DueAt),
		DueRuntimeHours:          int(row.DueRuntimeHours),
		TriggeredBy:              domain.Trigger(row.TriggeredBy),
		State:                    domain.TaskState(row.State),
		DoneAt:                   timeOf(row.DoneAt),
		DoneBy:                   row.DoneBy,
		Findings:                 row.Findings,
		EvidenceRef:              row.EvidenceRef,
		CertificateRef:           row.CertificateRef,
		CertificateExpiresAt:     timeOf(row.CertificateExpiresAt),
		WaivedReason:             row.WaivedReason,
		WorkOrderID:              uuidString(row.WorkOrderID),
		CreatedAt:                timeOf(row.CreatedAt),
		Version:                  row.Version,
	}
}

// InsertSchedule implements ports.MaintenanceRepository.
func (r *Repository) InsertSchedule(ctx context.Context,
	scope authctx.TenantScope, s domain.Schedule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(s.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesSchedule(ctx,
		sqlcgen.InsertFacilitiesScheduleParams{
			ID: id, TenantID: tenantID,
			AssetID: s.AssetID, FacilityID: s.FacilityID,
			Title: s.Title, Kind: string(s.Kind),
			TriggerKind:          string(s.Trigger),
			IntervalDays:         int32(s.IntervalDays),
			IntervalRuntimeHours: int32(s.IntervalRuntimeHours),
			Authority:            s.Authority,
			RequiresEvidence:     s.RequiresEvidence,
			WorkClassCode:        s.WorkClassCode,
			GraceDays:            int32(s.GraceDays),
			Active:               s.Active,
			CreatedAt:            stamp(s.CreatedAt),
			CreatedBy:            s.CreatedBy,
		})
	return err
}

// Schedule implements ports.MaintenanceRepository.
func (r *Repository) Schedule(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Schedule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Schedule{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Schedule{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesSchedule(ctx,
		sqlcgen.GetFacilitiesScheduleParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Schedule{}, notFound()
	}
	if err != nil {
		return domain.Schedule{}, err
	}
	return scheduleFrom(row), nil
}

// ScheduleProgress implements ports.MaintenanceRepository.
func (r *Repository) ScheduleProgress(ctx context.Context,
	scope authctx.TenantScope, id string) (time.Time, int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return time.Time{}, 0, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return time.Time{}, 0, err
	}
	row, err := r.queries(ctx).GetFacilitiesSchedule(ctx,
		sqlcgen.GetFacilitiesScheduleParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return time.Time{}, 0, notFound()
	}
	if err != nil {
		return time.Time{}, 0, err
	}
	return timeOf(row.LastDoneAt), int(row.LastDoneHours), nil
}

// SetScheduleDone implements ports.MaintenanceRepository.
func (r *Repository) SetScheduleDone(ctx context.Context,
	scope authctx.TenantScope, id string, at time.Time, hours int) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := parseID(id)
	if err != nil {
		return err
	}
	current, err := r.queries(ctx).GetFacilitiesSchedule(ctx,
		sqlcgen.GetFacilitiesScheduleParams{
			TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return notFound()
	}
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SetFacilitiesScheduleDone(ctx,
		sqlcgen.SetFacilitiesScheduleDoneParams{
			LastDoneAt: stamp(at), LastDoneHours: int32(hours),
			TenantID: tenantID, ID: parsed,
			ExpectedVersion: current.Version,
		})
	return conflict(err)
}

// Schedules implements ports.MaintenanceRepository.
func (r *Repository) Schedules(ctx context.Context,
	scope authctx.TenantScope, f ports.ScheduleFilter) (
	[]domain.Schedule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesSchedules(ctx,
		sqlcgen.ListFacilitiesSchedulesParams{
			TenantID: tenantID, AssetID: f.AssetID,
			FacilityID: f.FacilityID, Kind: string(f.Kind),
			ActiveOnly: f.ActiveOnly, RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Schedule, 0, len(found))
	for _, row := range found {
		out = append(out, scheduleFrom(row))
	}
	return out, nil
}

// InsertTask implements ports.MaintenanceRepository.
func (r *Repository) InsertTask(ctx context.Context,
	scope authctx.TenantScope, t domain.Task) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(t.ID)
	if err != nil {
		return err
	}
	scheduleID, err := parseID(t.ScheduleID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesTask(ctx,
		sqlcgen.InsertFacilitiesTaskParams{
			ID: id, TenantID: tenantID, ScheduleID: scheduleID,
			AssetID: t.AssetID, FacilityID: t.FacilityID,
			Title:                    t.Title,
			ScheduleKind:             string(t.ScheduleKind),
			ScheduleRequiresEvidence: t.ScheduleRequiresEvidence,
			DueAt:                    stampText(t.DueAt),
			DueRuntimeHours:          int32(t.DueRuntimeHours),
			TriggeredBy:              string(t.TriggeredBy),
			State:                    string(t.State),
			CreatedAt:                stamp(t.CreatedAt),
		})
	return uniqueViolation(err)
}

// Task implements ports.MaintenanceRepository.
func (r *Repository) Task(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Task, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Task{}, err
	}
	parsed, err := parseID(id)
	if err != nil {
		return domain.Task{}, err
	}
	row, err := r.queries(ctx).GetFacilitiesTask(ctx,
		sqlcgen.GetFacilitiesTaskParams{TenantID: tenantID, ID: parsed})
	if isNoRows(err) {
		return domain.Task{}, notFound()
	}
	if err != nil {
		return domain.Task{}, err
	}
	return taskFrom(row), nil
}

// UpdateTask implements ports.MaintenanceRepository.
func (r *Repository) UpdateTask(ctx context.Context,
	scope authctx.TenantScope, t domain.Task, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(t.ID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).UpdateFacilitiesTask(ctx,
		sqlcgen.UpdateFacilitiesTaskParams{
			State:  string(t.State),
			DoneAt: stampText(t.DoneAt), DoneBy: t.DoneBy,
			Findings:             t.Findings,
			EvidenceRef:          t.EvidenceRef,
			CertificateRef:       t.CertificateRef,
			CertificateExpiresAt: stampText(t.CertificateExpiresAt),
			WaivedReason:         t.WaivedReason,
			WorkOrderID:          t.WorkOrderID,
			TenantID:             tenantID, ID: id,
			ExpectedVersion: expectedVersion,
		})
	return conflict(err)
}

// Tasks implements ports.MaintenanceRepository.
func (r *Repository) Tasks(ctx context.Context, scope authctx.TenantScope,
	f ports.TaskFilter) ([]domain.Task, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	found, err := r.queries(ctx).ListFacilitiesTasks(ctx,
		sqlcgen.ListFacilitiesTasksParams{
			TenantID: tenantID, ScheduleID: f.ScheduleID,
			AssetID: f.AssetID, FacilityID: f.FacilityID,
			State: string(f.State), Kind: string(f.Kind),
			RowLimit: rows(f.Limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Task, 0, len(found))
	for _, row := range found {
		out = append(out, taskFrom(row))
	}
	return out, nil
}

// ------------------------------------- runtime counters (SRS-FAC-007)

var _ ports.RuntimeRepository = (*Repository)(nil)

func runtimeFrom(row sqlcgen.FacilitiesRuntimeReading) domain.RuntimeReading {
	return domain.RuntimeReading{
		ID: row.ID.String(), TenantID: row.TenantID.String(),
		AssetID: row.AssetID.String(), Hours: int(row.Hours),
		ReadAt: timeOf(row.ReadAt),
		Source: domain.Source(row.Source), SourceRef: row.SourceRef,
		RecordedBy:      row.RecordedBy,
		CounterReplaced: row.CounterReplaced, Note: row.Note,
		CreatedAt: timeOf(row.CreatedAt),
	}
}

// InsertRuntimeReading implements ports.RuntimeRepository.
func (r *Repository) InsertRuntimeReading(ctx context.Context,
	scope authctx.TenantScope, reading domain.RuntimeReading) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := parseID(reading.ID)
	if err != nil {
		return err
	}
	assetID, err := parseID(reading.AssetID)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).InsertFacilitiesRuntimeReading(ctx,
		sqlcgen.InsertFacilitiesRuntimeReadingParams{
			ID: id, TenantID: tenantID, AssetID: assetID,
			Hours: int32(reading.Hours), ReadAt: stamp(reading.ReadAt),
			Source: string(reading.Source), SourceRef: reading.SourceRef,
			RecordedBy:      reading.RecordedBy,
			CounterReplaced: reading.CounterReplaced,
			Note:            reading.Note,
			CreatedAt:       stamp(reading.CreatedAt),
		})
	return err
}

// LatestRuntime implements ports.RuntimeRepository.
func (r *Repository) LatestRuntime(ctx context.Context,
	scope authctx.TenantScope, assetID string) (
	domain.RuntimeReading, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RuntimeReading{}, false, err
	}
	parsed, err := parseID(assetID)
	if err != nil {
		return domain.RuntimeReading{}, false, err
	}
	row, err := r.queries(ctx).LatestFacilitiesRuntimeReading(ctx,
		sqlcgen.LatestFacilitiesRuntimeReadingParams{
			TenantID: tenantID, AssetID: parsed})
	if isNoRows(err) {
		// The first reading of a machine has nothing before it. Absent
		// is an answer, not a failure.
		return domain.RuntimeReading{}, false, nil
	}
	if err != nil {
		return domain.RuntimeReading{}, false, err
	}
	return runtimeFrom(row), true, nil
}

// RuntimeReadings implements ports.RuntimeRepository.
func (r *Repository) RuntimeReadings(ctx context.Context,
	scope authctx.TenantScope, assetID string, from, to time.Time,
	limit int32) ([]domain.RuntimeReading, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := parseID(assetID)
	if err != nil {
		return nil, err
	}
	windowFrom, windowTo := window(from, to)
	found, err := r.queries(ctx).ListFacilitiesRuntimeReadings(ctx,
		sqlcgen.ListFacilitiesRuntimeReadingsParams{
			TenantID: tenantID, AssetID: parsed,
			ReadFrom: stamp(windowFrom), ReadTo: stamp(windowTo),
			RowLimit: rows(limit),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.RuntimeReading, 0, len(found))
	for _, row := range found {
		out = append(out, runtimeFrom(row))
	}
	return out, nil
}
