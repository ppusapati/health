package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ReportExposureInput records an occupational exposure (SRS-IPC-007).
type ReportExposureInput struct {
	Reference       string
	StaffID         string
	Discipline      domain.Discipline
	FacilityID      string
	LocationID      string
	Kind            domain.ExposureKind
	Device          string
	Circumstance    string
	DeepInjury      bool
	SourcePatientID string
	SourceKnown     bool
	SourceConsented bool
	OccurredAt      time.Time
}

// ReportExposure records an exposure and starts its clocks (SRS-IPC-007).
//
// The steps are derived from the exposure rather than chosen by whoever took
// the report, and their deadlines run from the exposure rather than from the
// report: a member of staff who waited a day before telling anybody has a day
// less of prophylaxis window, not a fresh one.
func (s *Service) ReportExposure(ctx context.Context,
	in ReportExposureInput) (domain.Exposure, []domain.ExposureTask, error) {

	session, scope, err := s.authorize(ctx, PermExposureReport)
	if err != nil {
		return domain.Exposure{}, nil, err
	}
	now := s.clock.Now()

	staffID := in.StaffID
	if staffID == "" {
		staffID = session.SubjectID
	}

	exposure, err := domain.ReportExposure(s.ids.NewID(), session.TenantID,
		domain.NewExposureInput{
			Reference: in.Reference, StaffID: staffID,
			Discipline: in.Discipline, FacilityID: in.FacilityID,
			LocationID: in.LocationID, Kind: in.Kind, Device: in.Device,
			Circumstance: in.Circumstance, DeepInjury: in.DeepInjury,
			SourcePatientID: in.SourcePatientID,
			SourceKnown:     in.SourceKnown,
			SourceConsented: in.SourceConsented,
			OccurredAt:      in.OccurredAt,
		}, session.SubjectID, now)
	if err != nil {
		return domain.Exposure{}, nil, infectionError(err)
	}
	tasks := domain.ExposureTasks(exposure, s.ids.NewID)

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.exposures.InsertExposure(ctx, scope, exposure,
			tasks); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.exposure.reported",
			ResourceType: "ipc_exposure", ResourceID: exposure.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "reported an occupational exposure",
		}, now); err != nil {
			return err
		}
		// The kind, the device and the ward, so a prevention programme can
		// see the same cannula on the same ward three times. Never the member
		// of staff, and never the source patient.
		return s.appendEvent(ctx, session, EventExposureReported,
			"ipc_exposure", exposure.ID, map[string]any{
				"kind": string(exposure.Kind), "device": exposure.Device,
				"location_id": exposure.LocationID,
				"deep_injury": exposure.DeepInjury,
				"steps":       len(tasks),
			}, now)
	})
	if err != nil {
		return domain.Exposure{}, nil, infectionError(err)
	}
	return exposure, tasks, nil
}

// Exposure reads one exposure and its steps (SRS-IPC-007).
//
// Under its own permission, and every read is written to the audit trail. A
// staff health record that can be read without a trace is restricted in name
// only, and a hospital whose exposure records are readable by the ward is one
// whose staff stop reporting exposures.
func (s *Service) Exposure(ctx context.Context, exposureID string) (
	domain.Exposure, []domain.ExposureTask, error) {

	session, scope, err := s.authorize(ctx, PermExposureManage)
	if err != nil {
		return domain.Exposure{}, nil, err
	}
	now := s.clock.Now()

	exposure, err := s.exposures.Exposure(ctx, scope, exposureID)
	if err != nil {
		return domain.Exposure{}, nil, err
	}
	tasks, err := s.exposures.Tasks(ctx, scope, exposureID)
	if err != nil {
		return domain.Exposure{}, nil, err
	}
	if err := s.readExposure(ctx, session, exposureID, now); err != nil {
		return domain.Exposure{}, nil, err
	}
	return exposure, tasks, nil
}

// CompleteExposureTask records a step being done, declined or ruled out
// (SRS-IPC-007).
func (s *Service) CompleteExposureTask(ctx context.Context, exposureID,
	taskID string, to domain.TaskState, outcome string) (
	domain.ExposureTask, error) {

	session, scope, err := s.authorize(ctx, PermExposureManage)
	if err != nil {
		return domain.ExposureTask{}, err
	}
	now := s.clock.Now()

	var completed domain.ExposureTask
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		tasks, err := s.exposures.Tasks(ctx, scope, exposureID)
		if err != nil {
			return err
		}
		for _, task := range tasks {
			if task.ID != taskID {
				continue
			}
			if err := task.Complete(to, outcome, session.SubjectID,
				now); err != nil {
				return err
			}
			if err := s.exposures.UpdateTask(ctx, scope, task); err != nil {
				return err
			}
			completed = task
			return s.appendAudit(ctx, session, audit.Record{
				Action:       "infection.exposure_task.completed",
				ResourceType: "ipc_exposure", ResourceID: exposureID,
				Outcome: audit.OutcomeSuccess,
				Context: auditContext(map[string]string{
					"code": task.Code, "state": string(to),
				}),
				Reason: outcome,
			}, now)
		}
		return rpcerr.NotFound("IPC_NOT_FOUND",
			"no such step on this exposure")
	})
	if err != nil {
		return domain.ExposureTask{}, infectionError(err)
	}
	return completed, nil
}

// CloseExposure signs an exposure off (SRS-IPC-007).
func (s *Service) CloseExposure(ctx context.Context, exposureID,
	outcome string) (domain.Exposure, error) {

	session, scope, err := s.authorize(ctx, PermExposureManage)
	if err != nil {
		return domain.Exposure{}, err
	}
	now := s.clock.Now()

	var closed domain.Exposure
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		exposure, err := s.exposures.Exposure(ctx, scope, exposureID)
		if err != nil {
			return err
		}
		tasks, err := s.exposures.Tasks(ctx, scope, exposureID)
		if err != nil {
			return err
		}
		version := exposure.Version
		if err := exposure.CloseExposure(tasks, outcome, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.exposures.CloseExposure(ctx, scope, exposure,
			version); err != nil {
			return err
		}
		closed = exposure
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.exposure.closed",
			ResourceType: "ipc_exposure", ResourceID: exposure.ID,
			Outcome: audit.OutcomeSuccess, Reason: outcome,
		}, now)
	})
	if err != nil {
		return domain.Exposure{}, infectionError(err)
	}
	return closed, nil
}

// Exposures lists exposures (SRS-IPC-007).
func (s *Service) Exposures(ctx context.Context, f ports.ExposureFilter) (
	[]domain.Exposure, error) {

	session, scope, err := s.authorize(ctx, PermExposureManage)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()
	f.Limit = clampPageSize(f.Limit)

	out, err := s.exposures.Exposures(ctx, scope, f)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "infection.exposure.listed", ResourceType: "ipc_exposure",
		ResourceID: f.StaffID, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{"count": itoa(len(out))}),
		Reason:  "listed occupational exposure records",
	}, now); err != nil {
		return nil, err
	}
	return out, nil
}

// SweepExposureTasks escalates the follow-up steps that have run past the
// point they stop being useful (SRS-IPC-007).
//
// The notice names the exposure reference and the step, never the member of
// staff: an escalation is read by whoever is on call, and this is a staff
// health record.
func (s *Service) SweepExposureTasks(ctx context.Context) (int, error) {
	session, scope, err := s.authorize(ctx, PermExposureManage)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	raised := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		tasks, err := s.exposures.DueTasks(ctx, scope, now)
		if err != nil {
			return err
		}
		for _, task := range tasks {
			if err := s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationExposureStep, Subject: task.ExposureID,
				Summary: "occupational exposure step " + task.Code +
					" is past its window",
			}, now); err != nil {
				return err
			}
			raised++
		}
		return nil
	})
	if err != nil {
		return 0, infectionError(err)
	}
	return raised, nil
}
