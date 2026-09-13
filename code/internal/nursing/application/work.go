package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The care plan, the worklist and the handover
// (SRS-NUR-002, SRS-NUR-010, SRS-NUR-011).

// CreateCarePlan writes a nursing plan and the work it generates
// (SRS-NUR-002).
//
// The tasks are created in the same transaction as the plan, which is what
// makes "care-plan tasks appear in the nursing worklist" true rather than
// aspirational: a plan that committed without its work would leave a plan
// nobody is prompted to carry out.
func (s *Service) CreateCarePlan(ctx context.Context,
	in domain.NewCarePlanInput, scheduleUntil time.Time) (
	*domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "care_plan",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	plan, err := domain.NewCarePlan(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	// A plan's work is scheduled a shift ahead by default. Further ahead and
	// the worklist fills with tasks nobody will reach; not at all and the plan
	// prompts nothing.
	if scheduleUntil.IsZero() {
		scheduleUntil = now.Add(12 * time.Hour)
	}
	if scheduleUntil.After(now.Add(7 * 24 * time.Hour)) {
		return nil, rpcerr.Invalid("NUR_SCHEDULE_TOO_FAR",
			"a care plan schedules at most a week of work at a time")
	}
	work := plan.PlannedWork(now, scheduleUntil)
	if len(work) > MaxPageSize {
		return nil, rpcerr.Invalid("NUR_SCHEDULE_TOO_MUCH",
			"that plan would generate more work than one round can hold; "+
				"shorten the window or lengthen the intervals")
	}

	tasks := make([]*domain.NursingTask, 0, len(work))
	for _, w := range work {
		task, err := domain.NewTask(s.ids.NewID(), session.TenantID, w,
			session.SubjectID, now)
		if err != nil {
			return nil, nursingError(err)
		}
		tasks = append(tasks, task)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.plans.Insert(ctx, scope, plan); err != nil {
			return err
		}
		for _, task := range tasks {
			if err := s.tasks.Insert(ctx, scope, task); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.care_plan.create", ResourceType: "care_plan",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return plan, nil
}

// ReviewCarePlan records an evaluation (SRS-NUR-002).
func (s *Service) ReviewCarePlan(ctx context.Context, planID,
	evaluation string) (*domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "care_plan",
		planID, true)
	if err != nil {
		return nil, err
	}

	plan, err := s.plans.Get(ctx, scope, planID)
	if err != nil {
		return nil, err
	}
	expected := plan.Version

	now := s.clock.Now()
	if err := plan.Review(evaluation, session.SubjectID, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.plans.Update(ctx, scope, plan, expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.care_plan.review", ResourceType: "care_plan",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return plan, nil
}

// ListCarePlans reads an encounter's plans.
func (s *Service) ListCarePlans(ctx context.Context, encounterID,
	patientID string, activeOnly bool, limit int32) ([]*domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "care_plan",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	out, err := s.plans.List(ctx, scope, encounterID, activeOnly,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.care_plan.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// CreateTask adds a piece of nursing work (SRS-NUR-011).
func (s *Service) CreateTask(ctx context.Context, in domain.NewTaskInput) (
	*domain.NursingTask, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "task",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}
	if in.SourceKind == "" {
		in.SourceKind = domain.SourceManualTask
	}

	now := s.clock.Now()
	task, err := domain.NewTask(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.Insert(ctx, scope, task); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.task.create", ResourceType: "task",
			ResourceID: task.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return task, nil
}

// CompleteTask records work done and schedules the next occurrence
// (SRS-NUR-011).
func (s *Service) CompleteTask(ctx context.Context, taskID, evidence string) (
	*domain.NursingTask, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "task", taskID,
		true)
	if err != nil {
		return nil, err
	}

	task, err := s.tasks.Get(ctx, scope, taskID)
	if err != nil {
		return nil, err
	}
	expected := task.Version

	now := s.clock.Now()
	next, err := task.Complete(evidence, session.SubjectID, now, s.ids.NewID())
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.Close(ctx, scope, task, expected); err != nil {
			return err
		}
		if next != nil {
			// The next occurrence commits with the completion, so a recurring
			// observation set cannot stop recurring because a later write
			// failed.
			if err := s.tasks.Insert(ctx, scope, next); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.task.complete", ResourceType: "task",
			ResourceID: task.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return next, nil
}

// SkipTask records a deliberate omission (SRS-NUR-011).
func (s *Service) SkipTask(ctx context.Context, taskID, reason string) error {
	session, scope, err := s.authorize(ctx, PermNursingWrite, "task", taskID,
		true)
	if err != nil {
		return err
	}

	task, err := s.tasks.Get(ctx, scope, taskID)
	if err != nil {
		return err
	}
	expected := task.Version

	now := s.clock.Now()
	if err := task.NotDone(reason, session.SubjectID, now); err != nil {
		return nursingError(err)
	}

	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.Close(ctx, scope, task, expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.task.not_done", ResourceType: "task",
			ResourceID: task.ID, Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	}))
}

// Worklist reads nursing work, most urgent first (SRS-NUR-011).
func (s *Service) Worklist(ctx context.Context, q ports.WorklistQuery) (
	[]*domain.NursingTask, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "task",
		q.EncounterID, false)
	if err != nil {
		return nil, err
	}
	if q.EncounterID != "" {
		if _, err := s.requireOpenEncounterForRead(ctx, scope, q.EncounterID,
			""); err != nil {
			return nil, err
		}
	}

	q.Limit = clampPageSize(q.Limit)
	tasks, err := s.tasks.Worklist(ctx, scope, q)
	if err != nil {
		return nil, err
	}
	domain.SortWorklist(tasks)

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.worklist.read", ResourceType: "encounter",
		ResourceID: q.EncounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return tasks, nil
}

// EscalateOverdueWork raises overdue critical tasks (SRS-NUR-011).
//
// Critical only, and once each. Escalating every overdue routine task would
// produce a notification stream nobody reads, and the first thing lost in an
// unread stream is the critical one.
func (s *Service) EscalateOverdueWork(ctx context.Context, escalateTo string,
	limit int32) ([]*domain.NursingTask, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "task", "", true)
	if err != nil {
		return nil, err
	}
	if escalateTo == "" {
		return nil, rpcerr.Invalid("NUR_ESCALATION_NO_TARGET",
			"an escalation needs somebody to escalate to")
	}

	now := s.clock.Now()
	overdue, err := s.tasks.NeedingEscalation(ctx, scope, now,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	escalated := make([]*domain.NursingTask, 0, len(overdue))
	for _, task := range overdue {
		if err := task.Escalate(escalateTo, now); err != nil {
			// The row was selected as needing escalation and the domain
			// disagrees, which means somebody else got there between the query
			// and here. Skip it rather than failing the batch.
			continue
		}
		err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
			if err := s.tasks.Escalate(ctx, scope, task.ID, escalateTo,
				now); err != nil {
				return err
			}
			if err := s.appendAudit(ctx, session, audit.Record{
				Action: "nursing.task.escalate", ResourceType: "task",
				ResourceID: task.ID, Outcome: audit.OutcomeSuccess,
			}, now); err != nil {
				return err
			}
			return s.appendEvent(ctx, session, EventTaskEscalated, "task",
				task.ID, map[string]any{
					"task_id":      task.ID,
					"patient_id":   task.PatientID,
					"encounter_id": task.EncounterID,
					"priority":     string(task.Priority),
					"due_at":       timeOrNil(task.DueAt),
					"escalated_to": escalateTo,
				}, now)
		})
		if err != nil {
			// A task another worker escalated first is not a failure of this
			// run; the rest of the batch still needs raising.
			if isConflict(err) {
				continue
			}
			return nil, err
		}
		escalated = append(escalated, task)
	}
	return escalated, nil
}

func isConflict(err error) bool {
	e, ok := rpcerr.As(err)
	if ok {
		return e.Code == "NUR_VERSION_CONFLICT"
	}
	return err == ports.ErrVersionConflict
}

// ComposeHandover builds a shift handover from the ward's current state
// (SRS-NUR-010).
//
// A stored snapshot rather than a live view: rendered live, the handover
// acknowledged at 20:00 shows something different at 23:00 and nobody can say
// afterwards what they were told.
func (s *Service) ComposeHandover(ctx context.Context,
	in domain.NewHandoverInput) (*domain.Handover, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "handover",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()

	// Devices and outstanding work are captured here rather than supplied by
	// the caller, so a handover cannot quietly omit the line that has been in
	// for nine days.
	devices, err := s.devices.List(ctx, scope, in.EncounterID, true, MaxPageSize)
	if err != nil {
		return nil, err
	}
	for _, d := range devices {
		in.Devices = append(in.Devices, domain.HandoverDevice{
			DeviceID: d.ID, Kind: d.Kind, Site: d.Site,
			InsertedAt: d.InsertedAt, DeviceDays: d.DeviceDays(now),
		})
	}

	tasks, err := s.tasks.Worklist(ctx, scope, ports.WorklistQuery{
		EncounterID: in.EncounterID, PendingOnly: true, Limit: MaxPageSize,
	})
	if err != nil {
		return nil, err
	}
	domain.SortWorklist(tasks)
	for _, t := range tasks {
		in.PendingTasks = append(in.PendingTasks, domain.HandoverTask{
			TaskID: t.ID, Description: t.Description, Priority: t.Priority,
			DueAt: t.DueAt, Overdue: t.Overdue(now),
		})
	}

	handover, err := domain.NewHandover(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.handovers.Insert(ctx, scope, handover); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.handover.compose", ResourceType: "handover",
			ResourceID: handover.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return handover, nil
}

// AcknowledgeHandover records the incoming nurse accepting responsibility
// (SRS-NUR-010).
func (s *Service) AcknowledgeHandover(ctx context.Context, handoverID,
	questions string) (*domain.Handover, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "handover",
		handoverID, true)
	if err != nil {
		return nil, err
	}

	handover, err := s.handovers.Get(ctx, scope, handoverID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	if err := handover.Acknowledge(session.SubjectID, questions, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.handovers.Acknowledge(ctx, scope, handover); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.handover.acknowledge", ResourceType: "handover",
			ResourceID: handover.ID, Outcome: audit.OutcomeSuccess,
		}, now); err != nil {
			return err
		}
		// Emitted because the acknowledgement is the moment responsibility
		// moves, and other systems — an escalation policy, a staffing board —
		// need to know who holds the patient now.
		return s.appendEvent(ctx, session, EventHandoverAcknowledged, "handover",
			handover.ID, map[string]any{
				"handover_id":     handover.ID,
				"patient_id":      handover.PatientID,
				"encounter_id":    handover.EncounterID,
				"unit_id":         handover.UnitID,
				"from_shift":      handover.FromShift.Code,
				"to_shift":        handover.ToShift.Code,
				"composed_by":     handover.ComposedBy,
				"acknowledged_by": handover.AcknowledgedBy,
			}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return handover, nil
}

// ListHandovers reads handovers, optionally only the unaccepted ones.
func (s *Service) ListHandovers(ctx context.Context, encounterID string,
	unacknowledgedOnly bool, limit int32) ([]*domain.Handover, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "handover",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	out, err := s.handovers.List(ctx, scope, encounterID, unacknowledgedOnly,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.handover.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}
