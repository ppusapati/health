package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// TaskRepo persists nursing work (SRS-NUR-011).
type TaskRepo struct{ *Repository }

var _ ports.TaskRepository = TaskRepo{}

// NewTasks constructs the task adapter.
func NewTasks(r *Repository) TaskRepo { return TaskRepo{r} }

// Insert creates a task.
func (r TaskRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	t *domain.NursingTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	taskID, err := mustUUID(t.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(t.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(t.EncounterID)
	if err != nil {
		return err
	}

	sourceKind := string(t.SourceKind)
	if sourceKind == "" {
		sourceKind = string(domain.SourceManualTask)
	}

	return r.queries(ctx).InsertTask(ctx, sqlcgen.InsertTaskParams{
		TaskID: taskID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Description: t.Description, Priority: string(t.Priority),
		DueAt:      timestamptz(t.DueAt),
		SourceKind: sourceKind, SourceID: t.SourceID,
		RecurEverySeconds: int64(t.RecurEvery / time.Second),
		RecurUntil:        timestamptz(t.RecurUntil),
		AssignedTo:        t.AssignedTo,
		CreatedAt:         timestamptz(t.CreatedAt), CreatedBy: t.CreatedBy,
	})
}

// Get reads one task.
func (r TaskRepo) Get(ctx context.Context, scope authctx.TenantScope,
	taskID string) (*domain.NursingTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(taskID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetTask(ctx, sqlcgen.GetTaskParams{
		TenantID: tenantID, TaskID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return taskFromRow(sqlcgen.NursingTask(row)), nil
}

// Close records a task done or deliberately not done.
//
// Guarded on the task still being pending as well as on its version, so a
// second nurse completing the same task does not overwrite the first one's
// evidence.
func (r TaskRepo) Close(ctx context.Context, scope authctx.TenantScope,
	t *domain.NursingTask, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(t.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).CloseTask(ctx, sqlcgen.CloseTaskParams{
		TenantID: tenantID, TaskID: id,
		Status: string(t.Status), Evidence: t.Evidence,
		CompletedAt: timestamptz(t.CompletedAt), CompletedBy: t.CompletedBy,
		NotDoneReason: t.NotDoneReason, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// Escalate records that an overdue critical task was raised.
func (r TaskRepo) Escalate(ctx context.Context, scope authctx.TenantScope,
	taskID, escalatedTo string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(taskID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).EscalateTask(ctx, sqlcgen.EscalateTaskParams{
		TenantID: tenantID, TaskID: id,
		EscalatedAt: timestamptz(now), EscalatedTo: escalatedTo,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Already escalated, or no longer pending. Either way this call has
		// nothing left to do, and reporting a conflict lets the caller stop
		// rather than retrying into a loop.
		return conflict()
	}
	return nil
}

// Worklist reads nursing work, most urgent first.
func (r TaskRepo) Worklist(ctx context.Context, scope authctx.TenantScope,
	q ports.WorklistQuery) ([]*domain.NursingTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListWorklist(ctx, sqlcgen.ListWorklistParams{
		TenantID: tenantID, EncounterFilter: encounter,
		AssigneeFilter: q.AssignedTo, PendingOnly: q.PendingOnly,
		PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.NursingTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, taskFromRow(sqlcgen.NursingTask(row)))
	}
	return out, nil
}

// NeedingEscalation lists overdue critical work that has not been raised
// (SRS-NUR-011).
func (r TaskRepo) NeedingEscalation(ctx context.Context,
	scope authctx.TenantScope, asOf time.Time, limit int32) (
	[]*domain.NursingTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListTasksNeedingEscalation(ctx,
		sqlcgen.ListTasksNeedingEscalationParams{
			TenantID: tenantID, AsOf: timestamptz(asOf), PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.NursingTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.NursingTask{
			ID: row.TaskID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			Description: row.Description,
			Priority:    domain.TaskPriority(row.Priority),
			DueAt:       timeOrZero(row.DueAt),
			Status:      domain.TaskPending,
			AssignedTo:  row.AssignedTo,
			CreatedAt:   timeOrZero(row.CreatedAt), CreatedBy: row.CreatedBy,
			Version: row.Version,
		})
	}
	return out, nil
}

func taskFromRow(row sqlcgen.NursingTask) *domain.NursingTask {
	return &domain.NursingTask{
		ID: row.TaskID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Description: row.Description,
		Priority:    domain.TaskPriority(row.Priority),
		DueAt:       timeOrZero(row.DueAt),
		SourceKind:  domain.TaskSource(row.SourceKind), SourceID: row.SourceID,
		RecurEvery:  time.Duration(row.RecurEverySeconds) * time.Second,
		RecurUntil:  timeOrZero(row.RecurUntil),
		Status:      domain.TaskStatus(row.Status),
		Evidence:    row.Evidence,
		CompletedAt: timeOrZero(row.CompletedAt), CompletedBy: row.CompletedBy,
		NotDoneReason: row.NotDoneReason, AssignedTo: row.AssignedTo,
		EscalatedAt: timeOrZero(row.EscalatedAt), EscalatedTo: row.EscalatedTo,
		CreatedAt: timeOrZero(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// CarePlanRepo persists nursing care plans (SRS-NUR-002).
type CarePlanRepo struct{ *Repository }

var _ ports.CarePlanRepository = CarePlanRepo{}

// NewCarePlans constructs the care-plan adapter.
func NewCarePlans(r *Repository) CarePlanRepo { return CarePlanRepo{r} }

// Insert stores a plan.
func (r CarePlanRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	p *domain.CarePlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	planID, err := mustUUID(p.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(p.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(p.EncounterID)
	if err != nil {
		return err
	}
	problems, err := toJSON(p.Problems)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertNursingCarePlan(ctx,
		sqlcgen.InsertNursingCarePlanParams{
			PlanID: planID, TenantID: tenantID,
			PatientID: patientID, EncounterID: encounterID,
			Title: p.Title, Problems: problems,
			CreatedAt: timestamptz(p.CreatedAt), CreatedBy: p.CreatedBy,
		})
}

// Get reads one plan.
func (r CarePlanRepo) Get(ctx context.Context, scope authctx.TenantScope,
	planID string) (*domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(planID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetNursingCarePlan(ctx,
		sqlcgen.GetNursingCarePlanParams{TenantID: tenantID, PlanID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return carePlanFromRow(sqlcgen.NursingCarePlan(row))
}

// Update stores a revised plan.
func (r CarePlanRepo) Update(ctx context.Context, scope authctx.TenantScope,
	p *domain.CarePlan, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(p.ID)
	if err != nil {
		return err
	}
	problems, err := toJSON(p.Problems)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateNursingCarePlan(ctx,
		sqlcgen.UpdateNursingCarePlanParams{
			TenantID: tenantID, PlanID: id,
			Problems: problems, Status: string(p.Status),
			ReviewedAt: timestamptz(p.ReviewedAt), ReviewedBy: p.ReviewedBy,
			Evaluation: p.Evaluation, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// List reads an encounter's plans.
func (r CarePlanRepo) List(ctx context.Context, scope authctx.TenantScope,
	encounterID string, activeOnly bool, limit int32) ([]*domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListNursingCarePlans(ctx,
		sqlcgen.ListNursingCarePlansParams{
			TenantID: tenantID, EncounterID: id,
			ActiveOnly: activeOnly, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.CarePlan, 0, len(rows))
	for _, row := range rows {
		plan, err := carePlanFromRow(sqlcgen.NursingCarePlan(row))
		if err != nil {
			return nil, err
		}
		out = append(out, plan)
	}
	return out, nil
}

func carePlanFromRow(row sqlcgen.NursingCarePlan) (*domain.CarePlan, error) {
	p := &domain.CarePlan{
		ID: row.PlanID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Title: row.Title, Status: domain.PlanStatus(row.Status),
		CreatedAt: timeOrZero(row.CreatedAt), CreatedBy: row.CreatedBy,
		ReviewedAt: timeOrZero(row.ReviewedAt), ReviewedBy: row.ReviewedBy,
		Evaluation: row.Evaluation, Version: row.Version,
	}
	if err := fromJSON(row.Problems, &p.Problems); err != nil {
		return nil, err
	}
	return p, nil
}

// HandoverRepo persists shift handovers (SRS-NUR-010).
type HandoverRepo struct{ *Repository }

var _ ports.HandoverRepository = HandoverRepo{}

// NewHandovers constructs the handover adapter.
func NewHandovers(r *Repository) HandoverRepo { return HandoverRepo{r} }

// Insert stores a composed handover.
func (r HandoverRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	h *domain.Handover) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	handoverID, err := mustUUID(h.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(h.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(h.EncounterID)
	if err != nil {
		return err
	}
	devices, err := toJSON(h.Devices)
	if err != nil {
		return err
	}
	tasks, err := toJSON(h.PendingTasks)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertHandover(ctx, sqlcgen.InsertHandoverParams{
		HandoverID: handoverID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID, UnitID: h.UnitID,
		FromShiftCode:  h.FromShift.Code,
		FromShiftStart: timestamptz(h.FromShift.StartsAt),
		FromShiftEnd:   timestamptz(h.FromShift.EndsAt),
		ToShiftCode:    h.ToShift.Code,
		ToShiftStart:   timestamptz(h.ToShift.StartsAt),
		ToShiftEnd:     timestamptz(h.ToShift.EndsAt),
		Situation:      h.Situation, Background: h.Background,
		Assessment: h.Assessment, Recommendation: h.Recommendation,
		CriticalRisks: orEmpty(h.CriticalRisks),
		Outstanding:   orEmpty(h.OutstandingIssue),
		// The snapshot: what the handover said stays what it said.
		Devices: devices, PendingTasks: tasks,
		ComposedAt: timestamptz(h.ComposedAt), ComposedBy: h.ComposedBy,
	})
}

// Get reads one handover.
func (r HandoverRepo) Get(ctx context.Context, scope authctx.TenantScope,
	handoverID string) (*domain.Handover, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(handoverID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetHandover(ctx, sqlcgen.GetHandoverParams{
		TenantID: tenantID, HandoverID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return handoverFromRow(sqlcgen.NursingHandover(row))
}

// Acknowledge records the incoming nurse accepting responsibility.
//
// Guarded on the handover still being unacknowledged, so the record cannot be
// made to show responsibility transferring twice.
func (r HandoverRepo) Acknowledge(ctx context.Context, scope authctx.TenantScope,
	h *domain.Handover) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(h.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).AcknowledgeHandover(ctx,
		sqlcgen.AcknowledgeHandoverParams{
			TenantID: tenantID, HandoverID: id,
			AcknowledgedAt: timestamptz(h.AcknowledgedAt),
			AcknowledgedBy: h.AcknowledgedBy, Questions: h.Questions,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// List reads handovers.
func (r HandoverRepo) List(ctx context.Context, scope authctx.TenantScope,
	encounterID string, unacknowledgedOnly bool, limit int32) (
	[]*domain.Handover, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListHandovers(ctx, sqlcgen.ListHandoversParams{
		TenantID: tenantID, EncounterFilter: encounter,
		UnacknowledgedOnly: unacknowledgedOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Handover, 0, len(rows))
	for _, row := range rows {
		handover, err := handoverFromRow(sqlcgen.NursingHandover(row))
		if err != nil {
			return nil, err
		}
		out = append(out, handover)
	}
	return out, nil
}

func handoverFromRow(row sqlcgen.NursingHandover) (*domain.Handover, error) {
	h := &domain.Handover{
		ID: row.HandoverID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		UnitID: row.UnitID,
		FromShift: domain.Shift{
			Code: row.FromShiftCode, StartsAt: timeOrZero(row.FromShiftStart),
			EndsAt: timeOrZero(row.FromShiftEnd),
		},
		ToShift: domain.Shift{
			Code: row.ToShiftCode, StartsAt: timeOrZero(row.ToShiftStart),
			EndsAt: timeOrZero(row.ToShiftEnd),
		},
		Situation: row.Situation, Background: row.Background,
		Assessment: row.Assessment, Recommendation: row.Recommendation,
		CriticalRisks: row.CriticalRisks, OutstandingIssue: row.Outstanding,
		ComposedAt: timeOrZero(row.ComposedAt), ComposedBy: row.ComposedBy,
		AcknowledgedAt: timeOrZero(row.AcknowledgedAt),
		AcknowledgedBy: row.AcknowledgedBy, Questions: row.Questions,
		Version: row.Version,
	}
	if err := fromJSON(row.Devices, &h.Devices); err != nil {
		return nil, err
	}
	if err := fromJSON(row.PendingTasks, &h.PendingTasks); err != nil {
		return nil, err
	}
	return h, nil
}
