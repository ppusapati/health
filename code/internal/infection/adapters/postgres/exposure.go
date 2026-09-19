package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InsertExposure records an exposure and the steps it sets running
// (SRS-IPC-007).
//
// One call, because an exposure without its tasks is a member of staff nobody
// follows up, and the caller runs both inside one transaction.
func (r *Repository) InsertExposure(ctx context.Context,
	scope authctx.TenantScope, e domain.Exposure,
	tasks []domain.ExposureTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	exposureID, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_EXPOSURE_ID_INVALID",
			"exposure id must be a UUID")
	}

	queries := r.queries(ctx)
	if err := queries.InsertInfectionExposure(ctx,
		sqlcgen.InsertInfectionExposureParams{
			ExposureID: exposureID, TenantID: tenantID,
			Reference: e.Reference, StaffID: e.StaffID,
			Discipline: string(e.Discipline), FacilityID: e.FacilityID,
			LocationID: e.LocationID, Kind: string(e.Kind),
			Device: e.Device, Circumstance: e.Circumstance,
			DeepInjury:      e.DeepInjury,
			SourcePatientID: e.SourcePatientID,
			SourceKnown:     e.SourceKnown, SourceConsented: e.SourceConsented,
			OccurredAt: stamp(e.OccurredAt), ReportedAt: stamp(e.ReportedAt),
			ReportedBy: e.ReportedBy,
		}); err != nil {
		return err
	}

	for _, task := range tasks {
		taskID, err := uuid.Parse(task.ID)
		if err != nil {
			return rpcerr.Invalid("IPC_TASK_ID_INVALID",
				"task id must be a UUID")
		}
		if err := queries.InsertInfectionExposureTask(ctx,
			sqlcgen.InsertInfectionExposureTaskParams{
				TaskID: taskID, TenantID: tenantID, ExposureID: exposureID,
				Code: task.Code, DueBy: stamp(task.DueBy),
				State: string(task.State),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Exposure reads one exposure.
func (r *Repository) Exposure(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Exposure, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Exposure{}, err
	}
	exposureID, err := uuid.Parse(id)
	if err != nil {
		return domain.Exposure{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionExposure(ctx,
		sqlcgen.GetInfectionExposureParams{
			TenantID: tenantID, ExposureID: exposureID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Exposure{}, notFound()
	}
	if err != nil {
		return domain.Exposure{}, err
	}
	return exposureFrom(row), nil
}

// CloseExposure signs an exposure off.
func (r *Repository) CloseExposure(ctx context.Context,
	scope authctx.TenantScope, e domain.Exposure,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	exposureID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).CloseInfectionExposure(ctx,
		sqlcgen.CloseInfectionExposureParams{
			ClosedAt: stamp(e.ClosedAt), ClosedBy: e.ClosedBy,
			Outcome: e.Outcome, TenantID: tenantID, ExposureID: exposureID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Exposures lists exposures. Restricted reading is the application's to
// enforce; this returns what it is asked for.
func (r *Repository) Exposures(ctx context.Context,
	scope authctx.TenantScope, f ports.ExposureFilter) (
	[]domain.Exposure, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListInfectionExposures(ctx,
		sqlcgen.ListInfectionExposuresParams{
			TenantID: tenantID, StaffID: f.StaffID, OpenOnly: f.OpenOnly,
			OccurredFrom: stamp(from), OccurredTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Exposure, 0, len(rows))
	for _, row := range rows {
		out = append(out, exposureFrom(row))
	}
	return out, nil
}

func exposureFrom(row sqlcgen.InfectionExposure) domain.Exposure {
	return domain.Exposure{
		ID: row.ExposureID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, StaffID: row.StaffID,
		Discipline: domain.Discipline(row.Discipline),
		FacilityID: row.FacilityID, LocationID: row.LocationID,
		Kind: domain.ExposureKind(row.Kind), Device: row.Device,
		Circumstance: row.Circumstance, DeepInjury: row.DeepInjury,
		SourcePatientID: row.SourcePatientID,
		SourceKnown:     row.SourceKnown,
		SourceConsented: row.SourceConsented,
		OccurredAt:      timeOf(row.OccurredAt),
		ReportedAt:      timeOf(row.ReportedAt), ReportedBy: row.ReportedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Outcome: row.Outcome, Version: row.Version,
	}
}

// Tasks lists the steps an exposure set running.
func (r *Repository) Tasks(ctx context.Context, scope authctx.TenantScope,
	exposureID string) ([]domain.ExposureTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(exposureID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListInfectionExposureTasks(ctx,
		sqlcgen.ListInfectionExposureTasksParams{
			TenantID: tenantID, ExposureID: id,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ExposureTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, taskFrom(row))
	}
	return out, nil
}

// UpdateTask records a step being done, declined or ruled out. The WHERE
// clause holds state = 'due', so two people answering the same step at once
// do not both win.
func (r *Repository) UpdateTask(ctx context.Context,
	scope authctx.TenantScope, t domain.ExposureTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	taskID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionExposureTask(ctx,
		sqlcgen.UpdateInfectionExposureTaskParams{
			State: string(t.State), Outcome: t.Outcome,
			CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
			TenantID: tenantID, TaskID: taskID,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// DueTasks is the follow-up worklist.
func (r *Repository) DueTasks(ctx context.Context, scope authctx.TenantScope,
	before time.Time) ([]domain.ExposureTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if before.IsZero() {
		before = farFuture
	}

	rows, err := r.queries(ctx).ListInfectionDueExposureTasks(ctx,
		sqlcgen.ListInfectionDueExposureTasksParams{
			TenantID: tenantID, Before: stamp(before),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ExposureTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, taskFrom(row))
	}
	return out, nil
}

func taskFrom(row sqlcgen.InfectionExposureTask) domain.ExposureTask {
	return domain.ExposureTask{
		ID: row.TaskID.String(), TenantID: row.TenantID.String(),
		ExposureID: row.ExposureID.String(), Code: row.Code,
		DueBy: timeOf(row.DueBy), State: domain.TaskState(row.State),
		Outcome:     row.Outcome,
		CompletedAt: timeOf(row.CompletedAt), CompletedBy: row.CompletedBy,
	}
}
