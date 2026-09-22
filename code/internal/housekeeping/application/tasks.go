package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Cleaning tasks (SRS-HKP-002, SRS-HKP-004, SRS-HKP-006, SRS-HKP-007).

// RaiseTaskInput raises a piece of cleaning work.
type RaiseTaskInput struct {
	LocationCode string
	Kind         domain.TaskKind
	IncidentRef  string
	Detail       string
	AssigneeID   string
}

// RaiseTask raises cleaning work against the standard in force
// (SRS-HKP-002, SRS-HKP-006).
func (s *Service) RaiseTask(ctx context.Context, in RaiseTaskInput) (
	domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermTaskRaise)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	now := s.clock.Now()

	location, err := s.inForce(ctx, scope, in.LocationCode, now)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	if err := s.checkIncident(ctx, scope, in.Kind, in.IncidentRef); err != nil {
		return domain.CleaningTask{}, err
	}

	task, err := domain.RaiseTask(s.ids.NewID(), session.TenantID, location,
		domain.NewTaskInput{
			Kind: in.Kind, IncidentRef: in.IncidentRef,
			Detail: in.Detail, AssigneeID: in.AssigneeID,
		}, session.SubjectID, now)
	if err != nil {
		return domain.CleaningTask{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.InsertTask(ctx, scope, task); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTaskRaised,
			"cleaning_task", task.ID, map[string]any{
				"kind":          string(task.Kind),
				"location_code": task.LocationCode,
				"risk_class":    string(task.RiskClass),
				"restricted":    task.Restricted,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.task.raised",
			ResourceType: "cleaning_task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind":          string(task.Kind),
				"location_code": task.LocationCode,
			}),
		}, now)
	})
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return redact(session, task), nil
}

// checkIncident resolves a spill task's incident reference (SRS-HKP-006).
//
// SRS-HKP-006's acceptance is that the incident link is retained, and a link
// to an incident nobody can find is not retained. A deployment that has not
// wired the quality context records the reference unresolved; one that has
// said it requires the link refuses rather than storing a number somebody
// typed.
func (s *Service) checkIncident(ctx context.Context,
	scope authctx.TenantScope, kind domain.TaskKind, ref string) error {

	if kind != domain.TaskSpill || !s.config.RequireIncidentForSpill {
		return nil
	}
	if strings.TrimSpace(ref) == "" {
		return rpcerr.FailedPrecondition("HKP_SPILL_NEEDS_INCIDENT",
			"this deployment requires a spill clean to name its incident")
	}
	if s.incidents == nil {
		return rpcerr.FailedPrecondition("HKP_NO_INCIDENT_DIRECTORY",
			"this deployment requires a spill clean to name a resolvable "+
				"incident, but no incident directory is configured")
	}
	exists, err := s.incidents.Exists(ctx, scope, ref)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("HKP_NO_SUCH_INCIDENT",
			"no incident "+ref+" to link this spill clean to")
	}
	return nil
}

// AssignTask gives a task to somebody (SRS-HKP-002).
func (s *Service) AssignTask(ctx context.Context, taskID, assigneeID string) (
	domain.CleaningTask, error) {

	return s.mutate(ctx, PermTaskWork, taskID, "housekeeping.task.assigned",
		func(task *domain.CleaningTask, _ authctx.Session,
			_ time.Time) error {
			return task.Assign(assigneeID)
		})
}

// StartTask records somebody beginning the work (SRS-HKP-004).
func (s *Service) StartTask(ctx context.Context, taskID string) (
	domain.CleaningTask, error) {

	return s.mutate(ctx, PermTaskWork, taskID, "housekeeping.task.started",
		func(task *domain.CleaningTask, session authctx.Session,
			now time.Time) error {
			return task.Start(session.SubjectID, now)
		})
}

// CancelTask abandons a task that should not have been raised
// (SRS-HKP-002).
func (s *Service) CancelTask(ctx context.Context, taskID, reason string) (
	domain.CleaningTask, error) {

	return s.mutate(ctx, PermTaskWork, taskID, "housekeeping.task.cancelled",
		func(task *domain.CleaningTask, session authctx.Session,
			now time.Time) error {
			return task.Cancel(reason, session.SubjectID, now)
		})
}

// CompleteTask records the work done and the checklist answered
// (SRS-HKP-004).
//
// A terminal clean's hold is released in the same transaction. A bed that
// stayed held because the release was a second call is a bed nobody admits
// into until somebody notices, and the ward's answer to that is to stop
// trusting the board.
func (s *Service) CompleteTask(ctx context.Context, taskID string,
	answers []domain.ChecklistAnswer) (domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermTaskWork)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	now := s.clock.Now()

	task, err := s.tasks.Task(ctx, scope, taskID)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	version := task.Version
	if err := task.Complete(answers, session.SubjectID, now); err != nil {
		return domain.CleaningTask{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.UpdateTask(ctx, scope, task, version); err != nil {
			return housekeepingError(err)
		}
		if err := s.releaseHold(ctx, session, scope, task, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTaskCompleted,
			"cleaning_task", task.ID, map[string]any{
				"kind":          string(task.Kind),
				"location_code": task.LocationCode,
				"late":          !task.DueBy.IsZero() && now.After(task.DueBy),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.task.completed",
			ResourceType: "cleaning_task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location_code": task.LocationCode,
				"answers":       itoa(len(task.Answers)),
			}),
		}, now)
	})
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return redact(session, task), nil
}

// VerifyTask records a supervisor checking the work (SRS-HKP-004).
//
// Where a deployment holds beds until verification, this is where the bed
// comes back.
func (s *Service) VerifyTask(ctx context.Context, taskID, note string) (
	domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermVerify)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	now := s.clock.Now()

	task, err := s.tasks.Task(ctx, scope, taskID)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	version := task.Version
	if err := task.Verify(note, session.SubjectID, now); err != nil {
		return domain.CleaningTask{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.UpdateTask(ctx, scope, task, version); err != nil {
			return housekeepingError(err)
		}
		if err := s.releaseHold(ctx, session, scope, task, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTaskVerified,
			"cleaning_task", task.ID, map[string]any{
				"location_code": task.LocationCode,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.task.verified",
			ResourceType: "cleaning_task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess, Reason: note,
		}, now)
	})
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return redact(session, task), nil
}

// RecordScan attaches a location scan to a task (SRS-HKP-007).
//
// The caller is already authenticated and already allowed to work on the
// task. The scan adds evidence that they were in the room; it does not add
// permission, and a scan of the wrong door is recorded as a mismatch rather
// than refused — somebody scanned the wrong label or the label is wrong, and
// both are findings.
func (s *Service) RecordScan(ctx context.Context, taskID, code string) (
	domain.LocationScan, error) {

	session, scope, err := s.authorize(ctx, PermTaskWork)
	if err != nil {
		return domain.LocationScan{}, err
	}
	now := s.clock.Now()

	task, err := s.tasks.Task(ctx, scope, taskID)
	if err != nil {
		return domain.LocationScan{}, err
	}
	before := len(task.Scans)
	if err := task.RecordScan(code, session.SubjectID, now); err != nil {
		return domain.LocationScan{}, housekeepingError(err)
	}
	scan := task.Scans[before]

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.scans.AppendScan(ctx, scope, task.ID, scan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.task.scanned",
			ResourceType: "cleaning_task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"matched": boolText(scan.Matched),
			}),
		}, now)
	})
	if err != nil {
		return domain.LocationScan{}, err
	}
	return scan, nil
}

func boolText(b bool) string {
	if b {
		return "true"
	}
	return "false"
}

// mutate applies a small state change to a task under one permission.
func (s *Service) mutate(ctx context.Context, permission, taskID, action string,
	apply func(*domain.CleaningTask, authctx.Session, time.Time) error) (
	domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	now := s.clock.Now()

	task, err := s.tasks.Task(ctx, scope, taskID)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	version := task.Version
	if err := apply(&task, session, now); err != nil {
		return domain.CleaningTask{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.UpdateTask(ctx, scope, task, version); err != nil {
			return housekeepingError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "cleaning_task",
			ResourceID: task.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"state": string(task.State),
			}),
		}, now)
	})
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return redact(session, task), nil
}

// ListTasksInput narrows a worklist read.
type ListTasksInput struct {
	FacilityID   string
	Zone         string
	LocationCode string
	BedID        string
	Kind         string
	States       []string
	AssigneeID   string
	OpenOnly     bool
	From         time.Time
	To           time.Time
	PageSize     int32
	Offset       int32
}

// ListTasks reads the cleaning worklist (SRS-HKP-002, SRS-HKP-006).
//
// A restricted task appears with its detail removed for a caller who may not
// read it. The task stays on the list because somebody still has to clean it.
func (s *Service) ListTasks(ctx context.Context, in ListTasksInput) (
	[]domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	tasks, err := s.tasks.Tasks(ctx, scope, ports.TaskFilter{
		FacilityID: in.FacilityID, Zone: in.Zone,
		LocationCode: in.LocationCode, BedID: in.BedID, Kind: in.Kind,
		States: in.States, AssigneeID: in.AssigneeID, OpenOnly: in.OpenOnly,
		From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
	if err != nil {
		return nil, err
	}
	return redactAll(session, tasks), nil
}

// GetTask reads one cleaning task (SRS-HKP-004).
func (s *Service) GetTask(ctx context.Context, taskID string) (
	domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	task, err := s.tasks.Task(ctx, scope, taskID)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return redact(session, task), nil
}

// EscalateOverdue raises a notice for each overdue critical-area clean
// (SRS-HKP-005).
//
// Critical areas only, and once each. A channel that repeated every overdue
// office clean is one people filter, and the theatre goes with it.
func (s *Service) EscalateOverdue(ctx context.Context, facilityID string) (
	[]domain.CleaningTask, error) {

	session, scope, err := s.authorize(ctx, PermTaskRaise)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()
	batch := s.config.EscalationBatch
	if batch <= 0 {
		batch = defaultEscalationBatch
	}

	candidates, err := s.tasks.OverdueCritical(ctx, scope, facilityID, now,
		batch)
	if err != nil {
		return nil, err
	}
	raised := make([]domain.CleaningTask, 0, len(candidates))

	for _, task := range candidates {
		version := task.Version
		task.MarkEscalated(now)
		err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
			// The mark is written first and in the same transaction as the
			// notice. A notice raised without the mark is one raised again
			// on the next sweep, every sweep, until somebody mutes the
			// channel.
			if err := s.tasks.UpdateTask(ctx, scope, task,
				version); err != nil {
				return housekeepingError(err)
			}
			return s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationOverdue, Subject: task.ID,
				FacilityID: task.FacilityID,
				Summary: "overdue clean in a critical area: " +
					task.LocationCode,
			}, now)
		})
		if err != nil {
			return raised, err
		}
		raised = append(raised, redact(session, task))
	}
	return raised, nil
}
