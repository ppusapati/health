package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// AddScheduleInput writes a maintenance or inspection schedule
// (SRS-FAC-003, SRS-FAC-007).
type AddScheduleInput struct {
	AssetID              string
	FacilityID           string
	Title                string
	Kind                 string
	Trigger              string
	IntervalDays         int32
	IntervalRuntimeHours int32
	Authority            string
	RequiresEvidence     bool
	WorkClassCode        string
	GraceDays            int32
}

// AddSchedule writes a schedule (SRS-FAC-003, SRS-FAC-007).
func (s *Service) AddSchedule(ctx context.Context, in AddScheduleInput) (
	domain.Schedule, error) {

	session, scope, err := s.authorize(ctx, PermMaintenanceManage)
	if err != nil {
		return domain.Schedule{}, err
	}
	now := s.clock.Now()

	schedule := domain.Schedule{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		AssetID: in.AssetID, FacilityID: in.FacilityID,
		Title: in.Title, Kind: domain.MaintenanceKind(in.Kind),
		Trigger:              domain.Trigger(in.Trigger),
		IntervalDays:         int(in.IntervalDays),
		IntervalRuntimeHours: int(in.IntervalRuntimeHours),
		Authority:            in.Authority,
		RequiresEvidence:     in.RequiresEvidence,
		WorkClassCode:        in.WorkClassCode,
		GraceDays:            int(in.GraceDays),
		Active:               true,
		CreatedAt:            now.UTC(), CreatedBy: session.SubjectID,
		Version: 1,
	}
	if err := schedule.Validate(); err != nil {
		return domain.Schedule{}, facilitiesError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if schedule.AssetID != "" {
			if _, err := s.assets.Asset(ctx, scope,
				schedule.AssetID); err != nil {
				return err
			}
		}
		if err := s.maintenance.InsertSchedule(ctx, scope,
			schedule); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.schedule.added",
			ResourceType: "facilities.schedule", ResourceID: schedule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind":      string(schedule.Kind),
				"trigger":   string(schedule.Trigger),
				"authority": schedule.Authority,
			}),
		}, now)
	})
	if err != nil {
		return domain.Schedule{}, err
	}
	return schedule, nil
}

// PlanDue plans an occurrence for every schedule that has come round
// (SRS-FAC-003, SRS-FAC-007).
//
// The sweep that makes a runtime trigger real. A schedule that came due on
// hours rather than on the calendar produces a task that says so, which is
// SRS-FAC-007's acceptance: preventive maintenance can use a runtime trigger
// and can show that it did.
func (s *Service) PlanDue(ctx context.Context, facilityID string) (
	[]domain.Task, error) {

	session, scope, err := s.authorize(ctx, PermMaintenanceManage)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	var planned []domain.Task
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		schedules, err := s.maintenance.Schedules(ctx, scope,
			ports.ScheduleFilter{FacilityID: facilityID,
				ActiveOnly: true, Limit: reportPageSize})
		if err != nil {
			return err
		}

		for _, schedule := range schedules {
			lastAt, lastHours, err := s.maintenance.ScheduleProgress(
				ctx, scope, schedule.ID)
			if err != nil {
				return err
			}

			currentHours := lastHours
			if schedule.Trigger.UsesRuntime() && schedule.AssetID != "" {
				latest, found, err := s.runtime.LatestRuntime(ctx,
					scope, schedule.AssetID)
				if err != nil {
					return err
				}
				if found {
					currentHours = latest.Hours
				}
			}

			due, isDue := domain.NextDue(schedule, lastAt, lastHours,
				currentHours, now)
			if !isDue {
				continue
			}

			// An occurrence already outstanding is not planned
			// again. The database refuses a second one anyway; this
			// keeps the sweep from failing the whole batch on it.
			open, err := s.maintenance.Tasks(ctx, scope,
				ports.TaskFilter{ScheduleID: schedule.ID,
					State: domain.TaskPlanned, Limit: 1})
			if err != nil {
				return err
			}
			if len(open) > 0 {
				continue
			}

			task, err := domain.PlanTask(s.ids.NewID(), schedule,
				due.DueAt, due.DueRuntimeHours, due.By, now)
			if err != nil {
				return facilitiesError(err)
			}
			if err := s.maintenance.InsertTask(ctx, scope,
				task); err != nil {
				return err
			}
			planned = append(planned, task)

			if err := s.appendAudit(ctx, session, audit.Record{
				Action:       "facilities.task.planned",
				ResourceType: "facilities.task", ResourceID: task.ID,
				Outcome: audit.OutcomeSuccess,
				Context: auditContext(map[string]string{
					"schedule_id":       schedule.ID,
					"triggered_by":      string(due.By),
					"due_runtime_hours": itoa(due.DueRuntimeHours),
				}),
			}, now); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return planned, nil
}

// CompleteTaskInput records a maintenance task as done.
type CompleteTaskInput struct {
	TaskID               string
	Findings             string
	EvidenceRef          string
	CertificateRef       string
	CertificateExpiresAt string
	WorkOrderID          string
	RuntimeHours         int32
	Version              int64
}

// CompleteTask records a task as done (SRS-FAC-003).
//
// Completing a task also advances the schedule's clock and counter, so the
// next occurrence is measured from what actually happened rather than from
// when it was supposed to. A generator serviced three weeks late is next due
// three weeks later, not immediately.
func (s *Service) CompleteTask(ctx context.Context, in CompleteTaskInput) (
	domain.Task, error) {

	session, scope, err := s.authorize(ctx, PermMaintenanceComplete)
	if err != nil {
		return domain.Task{}, err
	}
	now := s.clock.Now()

	expires, err := parseTime(in.CertificateExpiresAt)
	if err != nil {
		return domain.Task{}, err
	}

	var out domain.Task
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		task, err := s.maintenance.Task(ctx, scope, in.TaskID)
		if err != nil {
			return err
		}
		if err := task.Complete(domain.CompleteInput{
			Findings: in.Findings, EvidenceRef: in.EvidenceRef,
			CertificateRef:       in.CertificateRef,
			CertificateExpiresAt: expires,
			WorkOrderID:          in.WorkOrderID,
		}, session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.maintenance.UpdateTask(ctx, scope, task,
			expected(in.Version, task.Version)); err != nil {
			return facilitiesError(err)
		}

		hours := int(in.RuntimeHours)
		if task.AssetID != "" && hours == 0 {
			// Prefer the machine's own counter over a number typed
			// into this call: the two disagreeing is how the next
			// service fires at the wrong time.
			if latest, found, err := s.runtime.LatestRuntime(ctx,
				scope, task.AssetID); err != nil {
				return err
			} else if found {
				hours = latest.Hours
			}
		}
		if err := s.maintenance.SetScheduleDone(ctx, scope,
			task.ScheduleID, now, hours); err != nil {
			return facilitiesError(err)
		}

		out = task
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.task.completed",
			ResourceType: "facilities.task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind":            string(task.ScheduleKind),
				"evidence_ref":    task.EvidenceRef,
				"certificate_ref": task.CertificateRef,
			}),
			Reason: task.Findings,
		}, now)
	})
	if err != nil {
		return domain.Task{}, err
	}
	return out, nil
}

// WaiveTaskInput records a task deliberately not done.
type WaiveTaskInput struct {
	TaskID  string
	Reason  string
	Version int64
}

// WaiveTask records a task nobody is going to do (SRS-FAC-003).
func (s *Service) WaiveTask(ctx context.Context, in WaiveTaskInput) (
	domain.Task, error) {

	session, scope, err := s.authorize(ctx, PermMaintenanceComplete)
	if err != nil {
		return domain.Task{}, err
	}
	now := s.clock.Now()

	var out domain.Task
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		task, err := s.maintenance.Task(ctx, scope, in.TaskID)
		if err != nil {
			return err
		}
		if err := task.Waive(in.Reason, session.SubjectID,
			now); err != nil {
			return facilitiesError(err)
		}
		if err := s.maintenance.UpdateTask(ctx, scope, task,
			expected(in.Version, task.Version)); err != nil {
			return facilitiesError(err)
		}
		out = task
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.task.waived",
			ResourceType: "facilities.task", ResourceID: task.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  task.WaivedReason,
		}, now)
	})
	if err != nil {
		return domain.Task{}, err
	}
	return out, nil
}

// TaskFilterInput narrows a task list.
type TaskFilterInput struct {
	ScheduleID string
	AssetID    string
	FacilityID string
	State      string
	Kind       string
	PageSize   int32
}

// ListTasks reads maintenance tasks (SRS-FAC-003).
func (s *Service) ListTasks(ctx context.Context, in TaskFilterInput) (
	[]domain.Task, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.maintenance.Tasks(ctx, scope, ports.TaskFilter{
		ScheduleID: in.ScheduleID, AssetID: in.AssetID,
		FacilityID: in.FacilityID,
		State:      domain.TaskState(in.State),
		Kind:       domain.MaintenanceKind(in.Kind),
		Limit:      clampPageSize(in.PageSize),
	})
}

// ListSchedules reads the configured schedules (SRS-FAC-003).
func (s *Service) ListSchedules(ctx context.Context, assetID,
	facilityID string, pageSize int32) ([]domain.Schedule, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.maintenance.Schedules(ctx, scope, ports.ScheduleFilter{
		AssetID: assetID, FacilityID: facilityID,
		Limit: clampPageSize(pageSize),
	})
}

// RecordRuntimeInput records an hour-counter reading (SRS-FAC-007).
type RecordRuntimeInput struct {
	AssetID         string
	Hours           int32
	ReadAt          string
	Source          string
	SourceRef       string
	CounterReplaced bool
	Note            string
}

// RecordRuntime records a counter reading and advances the asset's counter
// (SRS-FAC-007).
func (s *Service) RecordRuntime(ctx context.Context, in RecordRuntimeInput) (
	domain.RuntimeReading, error) {

	session, scope, err := s.authorize(ctx, PermRuntimeWrite)
	if err != nil {
		return domain.RuntimeReading{}, err
	}
	now := s.clock.Now()

	readAt, err := parseTime(in.ReadAt)
	if err != nil {
		return domain.RuntimeReading{}, err
	}
	if readAt.IsZero() {
		readAt = now
	}

	var out domain.RuntimeReading
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.assets.Asset(ctx, scope, in.AssetID); err != nil {
			return err
		}
		previous := 0
		if latest, found, err := s.runtime.LatestRuntime(ctx, scope,
			in.AssetID); err != nil {
			return err
		} else if found {
			previous = latest.Hours
		}

		reading, err := domain.RecordRuntime(s.ids.NewID(),
			session.TenantID, in.AssetID, int(in.Hours), readAt,
			domain.Source(in.Source), in.SourceRef,
			in.CounterReplaced, in.Note, session.SubjectID,
			previous, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.runtime.InsertRuntimeReading(ctx, scope,
			reading); err != nil {
			return err
		}
		if err := s.assets.UpdateAssetRuntime(ctx, scope, in.AssetID,
			reading.Hours, reading.ReadAt); err != nil {
			return facilitiesError(err)
		}
		out = reading
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.runtime.recorded",
			ResourceType: "facilities.asset", ResourceID: in.AssetID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"hours":            itoa(reading.Hours),
				"source":           string(reading.Source),
				"counter_replaced": boolText(reading.CounterReplaced),
			}),
		}, now)
	})
	if err != nil {
		return domain.RuntimeReading{}, err
	}
	return out, nil
}

// MaintenanceStatus is the due/overdue report SRS-FAC-003 asks for.
func (s *Service) MaintenanceStatus(ctx context.Context, facilityID string) (
	domain.MaintenanceReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return domain.MaintenanceReport{}, err
	}
	now := s.clock.Now()
	tasks, err := s.maintenance.Tasks(ctx, scope, ports.TaskFilter{
		FacilityID: facilityID, Limit: reportPageSize})
	if err != nil {
		return domain.MaintenanceReport{}, err
	}
	return domain.SummariseMaintenance(tasks, 0, now), nil
}
