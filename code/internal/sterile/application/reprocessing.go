package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// ReceiveInput takes a dirty set in.
type ReceiveInput struct {
	// SetCode rather than a set id: the technician scans the tray, and which
	// version of the packing list applies is this service's to resolve.
	SetCode      string
	SourceUnit   string
	SourceCaseID string
	Counted      map[string]int
}

// Receipt is what a receipt produced.
type Receipt struct {
	Run domain.Run
	// Short names the codes that arrived in fewer numbers than the list
	// expects. Returned rather than refused: the set is on the counter
	// whatever the count says.
	Short []string
}

// Receive takes a dirty set in (SRS-CSSD-002).
func (s *Service) Receive(ctx context.Context, in ReceiveInput) (Receipt, error) {
	session, scope, err := s.authorize(ctx, PermProcess)
	if err != nil {
		return Receipt{}, err
	}
	now := s.clock.Now()

	if err := s.knownCase(ctx, scope, in.SourceCaseID); err != nil {
		return Receipt{}, err
	}

	var out Receipt
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		set, exists, err := s.master.CurrentSet(ctx, scope, in.SetCode)
		if err != nil {
			return err
		}
		if !exists {
			// A set nobody has defined cannot be counted against anything, and
			// taking it in would start a chain with no packing list at the end
			// of it.
			return rpcerr.NotFound("CSSD_NOT_FOUND",
				"no set is defined for code "+in.SetCode)
		}

		run, short, err := domain.Receive(s.ids.NewID(), session.TenantID,
			domain.ReceiveInput{
				SetID: set.ID, SourceUnit: in.SourceUnit,
				SourceCaseID: in.SourceCaseID, Counted: in.Counted,
			}, set, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		// The domain attaches the receipt stage without an id, because minting
		// one is the service's job.
		for i := range run.Stages {
			if run.Stages[i].ID == "" {
				run.Stages[i].ID = s.ids.NewID()
			}
		}
		if err := s.runs.InsertRun(ctx, scope, run); err != nil {
			return err
		}
		out = Receipt{Run: run, Short: short}

		if err := s.appendEvent(ctx, session, EventSetReceived,
			"sterile_run", run.ID, map[string]any{
				"set_code":    run.SetCode,
				"set_version": run.SetVersion,
				"source_unit": run.SourceUnit,
				"short":       short,
			}, now); err != nil {
			return err
		}

		reason := "received " + run.SetCode + " from " + run.SourceUnit
		if len(short) > 0 {
			// The shortfall goes in the audit trail as well as the event,
			// because the moment of receipt is the last moment anybody can say
			// where a missing instrument was.
			reason += "; short: " + join(short)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermProcess,
			ResourceType: "sterile_run", ResourceID: run.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return Receipt{}, err
	}
	return out, nil
}

// AdvanceInput records one reprocessing stage.
type AdvanceInput struct {
	RunID     string
	Stage     domain.Stage
	Equipment string
	Notes     string

	// Skipped and its authorisation, for the exception SRS-CSSD-003 allows.
	Skipped          bool
	SkipAuthorisedBy string
	SkipReason       string
}

// Advance moves a run to its next stage (SRS-CSSD-003).
//
// Skipping needs its own permission. The sequence is the department's safety
// property, and the person who may step round it should not be whoever is at
// the bench.
func (s *Service) Advance(ctx context.Context, in AdvanceInput) (
	domain.StageRecord, error) {

	permission := PermProcess
	if in.Skipped {
		permission = PermAuthoriseSkip
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.StageRecord{}, err
	}
	now := s.clock.Now()

	// The authoriser is the caller. A field naming somebody else would let a
	// technician record a manager's approval without the manager being there.
	authorisedBy := in.SkipAuthorisedBy
	if in.Skipped {
		authorisedBy = session.SubjectID
	}

	var out domain.StageRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		run, err := s.runs.Run(ctx, scope, in.RunID)
		if err != nil {
			return err
		}

		record, err := run.Advance(s.ids.NewID(), domain.AdvanceInput{
			Stage: in.Stage, Equipment: in.Equipment, Notes: in.Notes,
			Skipped: in.Skipped, SkipAuthorisedBy: authorisedBy,
			SkipReason: in.SkipReason,
		}, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.runs.InsertStage(ctx, scope, record); err != nil {
			return err
		}
		if err := s.runs.UpdateRun(ctx, scope, run, run.Version); err != nil {
			return sterileError(err)
		}
		out = record

		if in.Skipped {
			if err := s.appendEvent(ctx, session, EventStageSkipped,
				"sterile_run", run.ID, map[string]any{
					"set_code":      run.SetCode,
					"stage":         string(in.Stage),
					"authorised_by": authorisedBy,
				}, now); err != nil {
				return err
			}
		}

		reason := string(in.Stage)
		if in.Skipped {
			reason = "skipped " + string(in.Stage) + ": " + in.SkipReason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "sterile_run", ResourceID: run.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.StageRecord{}, err
	}
	return out, nil
}

// AssembleInput records what went into the pack.
type AssembleInput struct {
	RunID    string
	Packed   map[string]int
	Replaced []string
	Notes    string
}

// Assembly is what an assembly produced.
type Assembly struct {
	Record domain.StageRecord
	// Missing names the non-critical items the pack went out without. A
	// critical shortfall refuses the assembly instead.
	Missing []string
}

// Assemble packs a tray against its versioned list (SRS-CSSD-004).
func (s *Service) Assemble(ctx context.Context, in AssembleInput) (
	Assembly, error) {

	session, scope, err := s.authorize(ctx, PermProcess)
	if err != nil {
		return Assembly{}, err
	}
	now := s.clock.Now()

	var out Assembly
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		run, err := s.runs.Run(ctx, scope, in.RunID)
		if err != nil {
			return err
		}
		// The version the run was received against, not whatever is current.
		// A revision published since must not change what this pack is
		// checked against.
		set, err := s.master.Set(ctx, scope, run.SetID)
		if err != nil {
			return err
		}

		record, missing, err := run.Assemble(s.ids.NewID(), domain.AssembleInput{
			Packed: in.Packed, Replaced: in.Replaced, Notes: in.Notes,
		}, set, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.runs.InsertStage(ctx, scope, record); err != nil {
			return err
		}
		if err := s.runs.UpdateRun(ctx, scope, run, run.Version); err != nil {
			return sterileError(err)
		}
		out = Assembly{Record: record, Missing: missing}

		reason := "assembled " + run.SetCode + " v" + itoa(run.SetVersion)
		if len(missing) > 0 {
			reason += "; short: " + join(missing)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermProcess,
			ResourceType: "sterile_run", ResourceID: run.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return Assembly{}, err
	}
	return out, nil
}

// PackageInput records how a pack was wrapped.
type PackageInput struct {
	RunID         string
	Method        string
	IndicatorType string
	Notes         string
}

// Package records packaging and the indicator (SRS-CSSD-005).
func (s *Service) Package(ctx context.Context, in PackageInput) (
	domain.StageRecord, error) {

	session, scope, err := s.authorize(ctx, PermProcess)
	if err != nil {
		return domain.StageRecord{}, err
	}
	now := s.clock.Now()

	var out domain.StageRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		run, err := s.runs.Run(ctx, scope, in.RunID)
		if err != nil {
			return err
		}
		record, err := run.Package(s.ids.NewID(), domain.PackageInput{
			Method: in.Method, IndicatorType: in.IndicatorType, Notes: in.Notes,
		}, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.runs.InsertStage(ctx, scope, record); err != nil {
			return err
		}
		if err := s.runs.UpdateRun(ctx, scope, run, run.Version); err != nil {
			return sterileError(err)
		}
		out = record
		return nil
	})
	if err != nil {
		return domain.StageRecord{}, err
	}
	return out, nil
}

// LoadInput puts packs into a sterilizer load.
type LoadInput struct {
	CycleID string
	RunIDs  []string
}

// Load attaches packs to a sterilizer load (SRS-CSSD-005).
//
// One call for the whole load rather than one per pack: a load is put in
// together, and a partial attachment would leave packs whose cycle is a
// different one from the packs beside them in the chamber.
func (s *Service) Load(ctx context.Context, in LoadInput) ([]domain.Run, error) {
	session, scope, err := s.authorize(ctx, PermProcess)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	var out []domain.Run
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		cycle, err := s.cycles.Cycle(ctx, scope, in.CycleID)
		if err != nil {
			return err
		}
		if cycle.Result != domain.CycleRunning {
			// A load that has already reported cannot take another pack: the
			// pack would carry a cycle record it was never in.
			return rpcerr.FailedPrecondition("CSSD_CYCLE_CLOSED",
				"load "+cycle.LoadNumber+" has already finished")
		}

		for _, runID := range in.RunIDs {
			run, err := s.runs.Run(ctx, scope, runID)
			if err != nil {
				return err
			}
			set, err := s.master.Set(ctx, scope, run.SetID)
			if err != nil {
				return err
			}

			shelfLife := s.config.shelfLifeFor(set)
			record, err := run.Sterilise(
				s.ids.NewID(), cycle, shelfLife, session.SubjectID, now)
			if err != nil {
				return sterileError(err)
			}
			if err := s.runs.InsertStage(ctx, scope, record); err != nil {
				return err
			}
			if err := s.runs.UpdateRun(ctx, scope, run, run.Version); err != nil {
				return sterileError(err)
			}
			out = append(out, run)
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermProcess,
			ResourceType: "sterile_cycle", ResourceID: cycle.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(len(out)) + " pack(s) into load " + cycle.LoadNumber,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// Run reads one reprocessing run with its stages.
func (s *Service) Run(ctx context.Context, runID string) (domain.Run, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Run{}, err
	}
	return s.runs.Run(ctx, scope, runID)
}

// Board is the department's work in progress (SRS-CSSD-003).
func (s *Service) Board(ctx context.Context, limit int32) ([]domain.Run, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.runs.InProgress(ctx, scope, clampPageSize(limit))
}

// Shelf is the released, in-date packs, soonest to expire first
// (SRS-CSSD-008).
func (s *Service) Shelf(ctx context.Context, setCode string, limit int32) (
	[]domain.Run, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.runs.Shelf(
		ctx, scope, setCode, s.clock.Now(), clampPageSize(limit))
}

// ExpiredPacks reads packs past their sterile life (SRS-CSSD-008).
func (s *Service) ExpiredPacks(ctx context.Context, limit int32) (
	[]domain.Run, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.runs.Expired(ctx, scope, s.clock.Now(), clampPageSize(limit))
}

// Exceptions is the register of skipped stages (SRS-CSSD-003).
func (s *Service) Exceptions(ctx context.Context, from, to time.Time,
	limit int32) ([]domain.StageRecord, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	if to.IsZero() {
		to = s.clock.Now()
	}
	if from.IsZero() {
		from = to.AddDate(0, -1, 0)
	}

	return s.runs.SkippedStages(ctx, scope, from, to, clampPageSize(limit))
}

// Label derives a pack's label (SRS-CSSD-008).
//
// Derived on read rather than stored: a label typed separately is a second
// account of what is in the pack, and it is the one the scrub nurse reads.
func (s *Service) Label(ctx context.Context, runID string) (domain.Label, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Label{}, err
	}

	run, err := s.runs.Run(ctx, scope, runID)
	if err != nil {
		return domain.Label{}, err
	}
	var cycle domain.Cycle
	if run.CycleID != "" {
		cycle, err = s.cycles.Cycle(ctx, scope, run.CycleID)
		if err != nil {
			return domain.Label{}, err
		}
	}
	return domain.BuildLabel(run, cycle), nil
}
