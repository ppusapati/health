package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// RunRepo implements ports.RunRepository.
type RunRepo struct{ *Repository }

var _ ports.RunRepository = RunRepo{}

// InsertRun takes a dirty set in.
//
// The receipt stage record goes with it in one transaction: a run whose first
// stage went missing is a chain of custody that begins nowhere, which is the
// whole of SRS-CSSD-002.
func (r RunRepo) InsertRun(ctx context.Context, scope authctx.TenantScope,
	run domain.Run) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	runID, err := uuid.Parse(run.ID)
	if err != nil {
		return notFound()
	}
	setID, err := uuid.Parse(run.SetID)
	if err != nil {
		return notFound()
	}
	sourceCaseID, err := optionalUUID(run.SourceCaseID)
	if err != nil {
		return err
	}
	received, err := counts0(run.ReceivedCount)
	if err != nil {
		return err
	}
	packed, err := counts0(run.PackedCount)
	if err != nil {
		return err
	}

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := r.queries(ctx).InsertRun(ctx, sqlcgen.InsertRunParams{
			RunID: runID, TenantID: tenantID,
			SetID: setID, SetVersion: int32(run.SetVersion),
			SetCode:    run.SetCode,
			SourceUnit: run.SourceUnit, SourceCaseID: sourceCaseID,
			Stage:         string(run.Stage),
			ReceivedCount: received, PackedCount: packed,
			Missing: strings0(run.Missing), Replaced: strings0(run.Replaced),
			StartedAt: stamp(run.StartedAt), StartedBy: run.StartedBy,
		}); err != nil {
			return err
		}
		for _, stage := range run.Stages {
			if stage.ID == "" {
				continue
			}
			if err := r.insertStage(ctx, tenantID, runID, stage); err != nil {
				return err
			}
		}
		return nil
	})
}

// Run reads one reprocessing run with its stages.
func (r RunRepo) Run(ctx context.Context, scope authctx.TenantScope,
	runID string) (domain.Run, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Run{}, err
	}
	id, err := uuid.Parse(runID)
	if err != nil {
		return domain.Run{}, notFound()
	}

	row, err := r.queries(ctx).GetRun(ctx, sqlcgen.GetRunParams{
		TenantID: tenantID, RunID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Run{}, notFound()
	}
	if err != nil {
		return domain.Run{}, err
	}

	run, err := runFrom(row)
	if err != nil {
		return domain.Run{}, err
	}
	// The stages travel with the run, because SkippedStages reads them and a
	// run fetched without them would report no exceptions.
	stages, err := r.Stages(ctx, scope, run.ID)
	if err != nil {
		return domain.Run{}, err
	}
	run.Stages = stages
	return run, nil
}

// UpdateRun records an advance, an assembly or a sterilisation.
func (r RunRepo) UpdateRun(ctx context.Context, scope authctx.TenantScope,
	run domain.Run, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	runID, err := uuid.Parse(run.ID)
	if err != nil {
		return notFound()
	}
	cycleID, err := optionalUUID(run.CycleID)
	if err != nil {
		return err
	}
	packed, err := counts0(run.PackedCount)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateRun(ctx, sqlcgen.UpdateRunParams{
		TenantID: tenantID, RunID: runID,
		Stage: string(run.Stage), PackedCount: packed,
		Missing: strings0(run.Missing), Replaced: strings0(run.Replaced),
		CycleID:         cycleID,
		PackagingMethod: run.PackagingMethod, IndicatorType: run.IndicatorType,
		SterilisedAt: stamp(run.SterilisedAt), ExpiresAt: stamp(run.ExpiresAt),
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// RunsForCycle reads the packs in one load.
func (r RunRepo) RunsForCycle(ctx context.Context, scope authctx.TenantScope,
	cycleID string) ([]domain.Run, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(cycleID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListRunsForCycle(ctx,
		sqlcgen.ListRunsForCycleParams{
			TenantID: tenantID,
			CycleID:  pgtypeUUID(id),
		})
	if err != nil {
		return nil, err
	}
	return r.withStages(ctx, scope, rows)
}

// InProgress is the department's own board.
func (r RunRepo) InProgress(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Run, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListRunsInProgress(ctx,
		sqlcgen.ListRunsInProgressParams{TenantID: tenantID, RowLimit: limit})
	if err != nil {
		return nil, err
	}
	return runsFrom(rows)
}

// Shelf is the released, in-date packs, soonest to expire first.
func (r RunRepo) Shelf(ctx context.Context, scope authctx.TenantScope,
	setCode string, asOf time.Time, limit int32) ([]domain.Run, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListShelf(ctx, sqlcgen.ListShelfParams{
		TenantID: tenantID, SetCode: setCode, AsOf: stamp(asOf),
		RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return runsFrom(rows)
}

// Expired reads packs past their sterile life.
func (r RunRepo) Expired(ctx context.Context, scope authctx.TenantScope,
	asOf time.Time, limit int32) ([]domain.Run, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListExpiredPacks(ctx,
		sqlcgen.ListExpiredPacksParams{
			TenantID: tenantID, AsOf: stamp(asOf), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return runsFrom(rows)
}

// withStages attaches each run's stage records.
//
// Used only where the caller needs the exceptions — a recall and a case trace
// both ask what was skipped. The list reads do not, because a board showing
// twenty runs does not need eight stage rows each.
func (r RunRepo) withStages(ctx context.Context, scope authctx.TenantScope,
	rows []sqlcgen.SterileRun) ([]domain.Run, error) {

	out, err := runsFrom(rows)
	if err != nil {
		return nil, err
	}
	for i := range out {
		stages, err := r.Stages(ctx, scope, out[i].ID)
		if err != nil {
			return nil, err
		}
		out[i].Stages = stages
	}
	return out, nil
}

func pgtypeUUID(id uuid.UUID) pgtype.UUID {
	return pgtype.UUID{Bytes: id, Valid: true}
}

func runsFrom(rows []sqlcgen.SterileRun) ([]domain.Run, error) {
	out := make([]domain.Run, 0, len(rows))
	for _, row := range rows {
		run, err := runFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, run)
	}
	return out, nil
}

func runFrom(row sqlcgen.SterileRun) (domain.Run, error) {
	received, err := countsFrom(row.ReceivedCount)
	if err != nil {
		return domain.Run{}, err
	}
	packed, err := countsFrom(row.PackedCount)
	if err != nil {
		return domain.Run{}, err
	}
	return domain.Run{
		ID: row.RunID.String(), TenantID: row.TenantID.String(),
		SetID: row.SetID.String(), SetVersion: int(row.SetVersion),
		SetCode:       row.SetCode,
		SourceUnit:    row.SourceUnit,
		SourceCaseID:  uuidOrEmpty(row.SourceCaseID),
		Stage:         domain.Stage(row.Stage),
		ReceivedCount: received, PackedCount: packed,
		Missing: row.Missing, Replaced: row.Replaced,
		CycleID:         uuidOrEmpty(row.CycleID),
		PackagingMethod: row.PackagingMethod,
		IndicatorType:   row.IndicatorType,
		SterilisedAt:    timeOf(row.SterilisedAt),
		ExpiresAt:       timeOf(row.ExpiresAt),
		StartedAt:       timeOf(row.StartedAt), StartedBy: row.StartedBy,
		Version: row.Version,
	}, nil
}

func (r RunRepo) insertStage(ctx context.Context, tenantID, runID uuid.UUID,
	s domain.StageRecord) error {

	stageID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	return r.queries(ctx).InsertStageRecord(ctx, sqlcgen.InsertStageRecordParams{
		StageRecordID: stageID, TenantID: tenantID, RunID: runID,
		Stage: string(s.Stage), Equipment: s.Equipment, Notes: s.Notes,
		Skipped: s.Skipped, SkipAuthorisedBy: s.SkipAuthorisedBy,
		SkipReason:  s.SkipReason,
		PerformedAt: stamp(s.PerformedAt), PerformedBy: s.PerformedBy,
	})
}

// InsertStage records one reprocessing step.
func (r RunRepo) InsertStage(ctx context.Context, scope authctx.TenantScope,
	s domain.StageRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	runID, err := uuid.Parse(s.RunID)
	if err != nil {
		return notFound()
	}
	return r.insertStage(ctx, tenantID, runID, s)
}

// Stages reads a run's steps, in order.
func (r RunRepo) Stages(ctx context.Context, scope authctx.TenantScope,
	runID string) ([]domain.StageRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(runID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListStageRecords(ctx,
		sqlcgen.ListStageRecordsParams{TenantID: tenantID, RunID: id})
	if err != nil {
		return nil, err
	}
	return stagesFrom(rows), nil
}

// SkippedStages is the exceptions register.
func (r RunRepo) SkippedStages(ctx context.Context, scope authctx.TenantScope,
	from, to time.Time, limit int32) ([]domain.StageRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListSkippedStages(ctx,
		sqlcgen.ListSkippedStagesParams{
			TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return stagesFrom(rows), nil
}

func stagesFrom(rows []sqlcgen.SterileStageRecord) []domain.StageRecord {
	out := make([]domain.StageRecord, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.StageRecord{
			ID: row.StageRecordID.String(), TenantID: row.TenantID.String(),
			RunID: row.RunID.String(), Stage: domain.Stage(row.Stage),
			Equipment: row.Equipment, Notes: row.Notes,
			Skipped: row.Skipped, SkipAuthorisedBy: row.SkipAuthorisedBy,
			SkipReason:  row.SkipReason,
			PerformedAt: timeOf(row.PerformedAt), PerformedBy: row.PerformedBy,
		})
	}
	return out
}
