package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// CycleRepo implements ports.CycleRepository.
type CycleRepo struct{ *Repository }

var _ ports.CycleRepository = CycleRepo{}

// InsertCycle records a sterilizer load.
func (r CycleRepo) InsertCycle(ctx context.Context, scope authctx.TenantScope,
	c domain.Cycle) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	cycleID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	parameters, err := marshalParameters(c.Parameters)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertCycle(ctx, sqlcgen.InsertCycleParams{
		CycleID: cycleID, TenantID: tenantID,
		Machine: c.Machine, LoadNumber: c.LoadNumber, Program: c.Program,
		Parameters: parameters, Source: string(c.Source),
		Result:    string(c.Result),
		StartedAt: stamp(c.StartedAt), StartedBy: c.StartedBy,
	})
}

// marshalParameters encodes the machine's readings, never as NULL.
func marshalParameters(in map[string]float64) ([]byte, error) {
	if in == nil {
		in = map[string]float64{}
	}
	return json.Marshal(in)
}

// Cycle reads one load with its indicators.
func (r CycleRepo) Cycle(ctx context.Context, scope authctx.TenantScope,
	cycleID string) (domain.Cycle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Cycle{}, err
	}
	id, err := uuid.Parse(cycleID)
	if err != nil {
		return domain.Cycle{}, notFound()
	}

	row, err := r.queries(ctx).GetCycle(ctx, sqlcgen.GetCycleParams{
		TenantID: tenantID, CycleID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Cycle{}, notFound()
	}
	if err != nil {
		return domain.Cycle{}, err
	}

	cycle, err := cycleFrom(row)
	if err != nil {
		return domain.Cycle{}, err
	}
	// The indicators travel with the load, because every release decision
	// reads them and a cycle fetched without them would look releasable.
	indicators, err := r.Indicators(ctx, scope, cycle.ID)
	if err != nil {
		return domain.Cycle{}, err
	}
	cycle.Indicators = indicators
	return cycle, nil
}

// CycleByLoad finds the load from the number on the printout.
func (r CycleRepo) CycleByLoad(ctx context.Context, scope authctx.TenantScope,
	machine, loadNumber string) (domain.Cycle, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Cycle{}, false, err
	}
	row, err := r.queries(ctx).GetCycleByLoad(ctx, sqlcgen.GetCycleByLoadParams{
		TenantID: tenantID, Machine: machine, LoadNumber: loadNumber,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Cycle{}, false, nil
	}
	if err != nil {
		return domain.Cycle{}, false, err
	}
	cycle, err := cycleFrom(row)
	if err != nil {
		return domain.Cycle{}, false, err
	}
	indicators, err := r.Indicators(ctx, scope, cycle.ID)
	if err != nil {
		return domain.Cycle{}, false, err
	}
	cycle.Indicators = indicators
	return cycle, true, nil
}

// UpdateCycle records a result or a release.
func (r CycleRepo) UpdateCycle(ctx context.Context, scope authctx.TenantScope,
	c domain.Cycle, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	cycleID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	parameters, err := marshalParameters(c.Parameters)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateCycle(ctx, sqlcgen.UpdateCycleParams{
		TenantID: tenantID, CycleID: cycleID,
		Result: string(c.Result), Parameters: parameters,
		EndedAt:  stamp(c.EndedAt),
		Released: c.Released, ReleasedBy: c.ReleasedBy,
		ReleasedAt: stamp(c.ReleasedAt), ReleaseNote: c.ReleaseNote,
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

// AwaitingRelease is the loads that finished and have not been cleared.
func (r CycleRepo) AwaitingRelease(ctx context.Context,
	scope authctx.TenantScope, limit int32) ([]domain.Cycle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListCyclesAwaitingRelease(ctx,
		sqlcgen.ListCyclesAwaitingReleaseParams{
			TenantID: tenantID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return r.withIndicators(ctx, scope, rows)
}

// CyclesForMachine reads one sterilizer's history.
func (r CycleRepo) CyclesForMachine(ctx context.Context,
	scope authctx.TenantScope, machine string, from, to time.Time,
	limit int32) ([]domain.Cycle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListCyclesForMachine(ctx,
		sqlcgen.ListCyclesForMachineParams{
			TenantID: tenantID, Machine: machine,
			PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return r.withIndicators(ctx, scope, rows)
}

// withIndicators attaches each load's indicators.
//
// One query per load rather than a join, because a list of loads is short — a
// department runs tens of them a day — and the join would fan out the cycle
// row per indicator for a caller that then has to fold it back.
func (r CycleRepo) withIndicators(ctx context.Context,
	scope authctx.TenantScope, rows []sqlcgen.SterileCycle) (
	[]domain.Cycle, error) {

	out := make([]domain.Cycle, 0, len(rows))
	for _, row := range rows {
		cycle, err := cycleFrom(row)
		if err != nil {
			return nil, err
		}
		indicators, err := r.Indicators(ctx, scope, cycle.ID)
		if err != nil {
			return nil, err
		}
		cycle.Indicators = indicators
		out = append(out, cycle)
	}
	return out, nil
}

func cycleFrom(row sqlcgen.SterileCycle) (domain.Cycle, error) {
	parameters := map[string]float64{}
	if len(row.Parameters) > 0 {
		if err := json.Unmarshal(row.Parameters, &parameters); err != nil {
			return domain.Cycle{}, err
		}
	}
	return domain.Cycle{
		ID: row.CycleID.String(), TenantID: row.TenantID.String(),
		Machine: row.Machine, LoadNumber: row.LoadNumber, Program: row.Program,
		Parameters: parameters, Source: domain.CycleSource(row.Source),
		Result:   domain.CycleResult(row.Result),
		Released: row.Released, ReleasedBy: row.ReleasedBy,
		ReleasedAt: timeOf(row.ReleasedAt), ReleaseNote: row.ReleaseNote,
		StartedAt: timeOf(row.StartedAt), EndedAt: timeOf(row.EndedAt),
		StartedBy: row.StartedBy, Version: row.Version,
	}, nil
}

// InsertIndicator records one indicator read.
func (r CycleRepo) InsertIndicator(ctx context.Context,
	scope authctx.TenantScope, i domain.IndicatorResult) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	indicatorID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	cycleID, err := uuid.Parse(i.CycleID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertIndicator(ctx, sqlcgen.InsertIndicatorParams{
		IndicatorID: indicatorID, TenantID: tenantID, CycleID: cycleID,
		Kind: string(i.Kind), Lot: i.Lot, Passed: i.Passed, Notes: i.Notes,
		ReadAt: stamp(i.ReadAt), ReadBy: i.ReadBy,
	})
}

// Indicators reads a load's indicators, in order.
func (r CycleRepo) Indicators(ctx context.Context, scope authctx.TenantScope,
	cycleID string) ([]domain.IndicatorResult, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(cycleID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIndicators(ctx, sqlcgen.ListIndicatorsParams{
		TenantID: tenantID, CycleID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.IndicatorResult, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.IndicatorResult{
			ID: row.IndicatorID.String(), TenantID: row.TenantID.String(),
			CycleID: row.CycleID.String(),
			Kind:    domain.IndicatorKind(row.Kind), Lot: row.Lot,
			Passed: row.Passed, Notes: row.Notes,
			ReadAt: timeOf(row.ReadAt), ReadBy: row.ReadBy,
		})
	}
	return out, nil
}

// ClearedByLot runs the bad-batch investigation.
func (r CycleRepo) ClearedByLot(ctx context.Context, scope authctx.TenantScope,
	lot string, limit int32) ([]domain.Cycle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListCyclesClearedByLot(ctx,
		sqlcgen.ListCyclesClearedByLotParams{
			TenantID: tenantID, Lot: lot, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return r.withIndicators(ctx, scope, rows)
}
