package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// StartCycle records a sterilizer load (SRS-CSSD-006).
func (s *Service) StartCycle(ctx context.Context, in domain.NewCycleInput) (
	domain.Cycle, error) {

	session, scope, err := s.authorize(ctx, PermRunCycle)
	if err != nil {
		return domain.Cycle{}, err
	}
	now := s.clock.Now()

	cycle, err := domain.StartCycle(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Cycle{}, sterileError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.cycles.InsertCycle(ctx, scope, cycle); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRunCycle,
			ResourceType: "sterile_cycle", ResourceID: cycle.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "load " + cycle.LoadNumber + " started on " + cycle.Machine,
		}, now)
	})
	if err != nil {
		return domain.Cycle{}, err
	}
	return cycle, nil
}

// FinishCycle records the sterilizer's verdict (SRS-CSSD-006).
//
// A failed or aborted load publishes an event of its own, so a quality system
// can subscribe to it without filtering every cycle the department runs.
func (s *Service) FinishCycle(ctx context.Context, cycleID string,
	result domain.CycleResult, parameters map[string]float64,
	endedAt time.Time) (domain.Cycle, error) {

	session, scope, err := s.authorize(ctx, PermRunCycle)
	if err != nil {
		return domain.Cycle{}, err
	}
	now := s.clock.Now()
	if endedAt.IsZero() {
		endedAt = now
	}

	var out domain.Cycle
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		cycle, err := s.cycles.Cycle(ctx, scope, cycleID)
		if err != nil {
			return err
		}
		if err := cycle.Finish(result, parameters, endedAt); err != nil {
			return sterileError(err)
		}
		if err := s.cycles.UpdateCycle(
			ctx, scope, cycle, cycle.Version); err != nil {
			return sterileError(err)
		}
		out = cycle

		eventType := EventCycleFinished
		if result != domain.CyclePassed {
			eventType = EventCycleFailed
		}
		if err := s.appendEvent(ctx, session, eventType,
			"sterile_cycle", cycle.ID, map[string]any{
				"machine":     cycle.Machine,
				"load_number": cycle.LoadNumber,
				"program":     cycle.Program,
				"result":      string(result),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRunCycle,
			ResourceType: "sterile_cycle", ResourceID: cycle.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "load " + cycle.LoadNumber + " " + string(result),
		}, now)
	})
	if err != nil {
		return domain.Cycle{}, err
	}
	return out, nil
}

// RecordIndicator reads an indicator against a load (SRS-CSSD-007).
func (s *Service) RecordIndicator(ctx context.Context, cycleID string,
	kind domain.IndicatorKind, lot string, passed bool, notes string) (
	domain.IndicatorResult, error) {

	session, scope, err := s.authorize(ctx, PermRunCycle)
	if err != nil {
		return domain.IndicatorResult{}, err
	}
	now := s.clock.Now()

	var out domain.IndicatorResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		cycle, err := s.cycles.Cycle(ctx, scope, cycleID)
		if err != nil {
			return err
		}
		result, err := cycle.RecordIndicator(s.ids.NewID(), kind, lot, passed,
			notes, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.cycles.InsertIndicator(ctx, scope, result); err != nil {
			return err
		}
		out = result

		if passed {
			return nil
		}
		// A failed indicator is a governance event whether or not anybody
		// releases the load: the quality system needs it, and so does the
		// person deciding whether to recall the loads this lot cleared.
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRunCycle,
			ResourceType: "sterile_cycle", ResourceID: cycle.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: string(kind) + " indicator lot " + lot +
				" FAILED on load " + cycle.LoadNumber + ": " + notes,
		}, now)
	})
	if err != nil {
		return domain.IndicatorResult{}, err
	}
	return out, nil
}

// ReleaseDecision reports whether a load may be distributed (SRS-CSSD-007).
func (s *Service) ReleaseDecision(ctx context.Context, cycleID string) (
	domain.ReleaseDecision, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ReleaseDecision{}, err
	}
	cycle, err := s.cycles.Cycle(ctx, scope, cycleID)
	if err != nil {
		return domain.ReleaseDecision{}, err
	}
	return cycle.EvaluateRelease(s.config.RequireBiologicalIndicator), nil
}

// ReleaseLoad authorises a load and every pack in it (SRS-CSSD-007).
//
// The decision is recomputed here, inside the transaction, from rows read
// here. This is the step that makes an untested pack usable, so a client that
// could assert "the indicators passed" would be the control.
func (s *Service) ReleaseLoad(ctx context.Context, cycleID, note string) (
	domain.Cycle, []domain.Run, error) {

	session, scope, err := s.authorize(ctx, PermRelease)
	if err != nil {
		return domain.Cycle{}, nil, err
	}
	now := s.clock.Now()

	var releasedCycle domain.Cycle
	var releasedRuns []domain.Run

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		cycle, err := s.cycles.Cycle(ctx, scope, cycleID)
		if err != nil {
			return err
		}

		decision := cycle.EvaluateRelease(s.config.RequireBiologicalIndicator)
		if err := cycle.Release(
			decision, note, session.SubjectID, now); err != nil {
			return sterileError(err)
		}
		if err := s.cycles.UpdateCycle(
			ctx, scope, cycle, cycle.Version); err != nil {
			return sterileError(err)
		}
		releasedCycle = cycle

		runs, err := s.runs.RunsForCycle(ctx, scope, cycle.ID)
		if err != nil {
			return err
		}
		for _, run := range runs {
			if run.Stage == domain.StageReleased {
				continue
			}
			record, err := run.ReleaseRun(
				s.ids.NewID(), cycle, session.SubjectID, now)
			if err != nil {
				return sterileError(err)
			}
			if err := s.runs.InsertStage(ctx, scope, record); err != nil {
				return err
			}
			if err := s.runs.UpdateRun(ctx, scope, run, run.Version); err != nil {
				return sterileError(err)
			}
			releasedRuns = append(releasedRuns, run)
		}

		if err := s.appendEvent(ctx, session, EventCycleReleased,
			"sterile_cycle", cycle.ID, map[string]any{
				"machine":     cycle.Machine,
				"load_number": cycle.LoadNumber,
				"packs":       len(releasedRuns),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRelease,
			ResourceType: "sterile_cycle", ResourceID: cycle.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "load " + cycle.LoadNumber + " released, " +
				itoa(len(releasedRuns)) + " pack(s)",
		}, now)
	})
	if err != nil {
		return domain.Cycle{}, nil, err
	}
	return releasedCycle, releasedRuns, nil
}

// Cycle reads one load with its indicators.
func (s *Service) Cycle(ctx context.Context, cycleID string) (
	domain.Cycle, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Cycle{}, err
	}
	return s.cycles.Cycle(ctx, scope, cycleID)
}

// CycleByLoad finds a load from the number on the printout.
func (s *Service) CycleByLoad(ctx context.Context, machine, loadNumber string) (
	domain.Cycle, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Cycle{}, err
	}
	cycle, ok, err := s.cycles.CycleByLoad(ctx, scope, machine, loadNumber)
	if err != nil {
		return domain.Cycle{}, err
	}
	if !ok {
		return domain.Cycle{}, rpcerr.NotFound("CSSD_NOT_FOUND", "no such load")
	}
	return cycle, nil
}

// AwaitingRelease is the loads that finished and have not been cleared
// (SRS-CSSD-007).
func (s *Service) AwaitingRelease(ctx context.Context, limit int32) (
	[]domain.Cycle, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.cycles.AwaitingRelease(ctx, scope, clampPageSize(limit))
}

// LoadsClearedByLot runs the bad-batch investigation (SRS-CSSD-007,
// SRS-CSSD-011).
//
// From an indicator lot to every load it cleared. Its own audited read,
// because the answer is the input to a recall: a bad batch invalidates every
// load it passed.
func (s *Service) LoadsClearedByLot(ctx context.Context, lot string,
	limit int32) ([]domain.Cycle, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	cycles, err := s.cycles.ClearedByLot(ctx, scope, lot, clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermTrace,
		ResourceType: "sterile_indicator_lot", ResourceID: lot,
		Outcome: audit.OutcomeSuccess,
		Reason: "indicator lot " + lot + " cleared " + itoa(len(cycles)) +
			" load(s)",
	}, now); err != nil {
		return nil, err
	}
	return cycles, nil
}
