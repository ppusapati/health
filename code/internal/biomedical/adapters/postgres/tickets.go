package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// TicketRepo implements ports.TicketRepository.
type TicketRepo struct{ *Repository }

var _ ports.TicketRepository = TicketRepo{}

// InsertTicket raises a breakdown or service request.
func (r TicketRepo) InsertTicket(ctx context.Context,
	scope authctx.TenantScope, t domain.Ticket) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ticketID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	assetID, err := uuid.Parse(t.AssetID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTicket(ctx, sqlcgen.InsertTicketParams{
		TicketID: ticketID, TenantID: tenantID,
		Number: t.Number, Kind: string(t.Kind), AssetID: assetID,
		PlanID: optionalUUID(t.PlanID), AssetTag: t.AssetTag,
		LocationID: t.LocationID, Symptom: t.Symptom,
		Priority: string(t.Priority), Impact: string(t.Impact),
		State: string(t.State), OwnerID: t.OwnerID,
		RespondBy: stamp(t.RespondBy), ResolveBy: stamp(t.ResolveBy),
		ContractID: optionalUUID(t.ContractID),
		DownFrom:   stamp(t.DownFrom),
		RaisedAt:   stamp(t.RaisedAt), RaisedBy: t.RaisedBy,
	})
}

// Ticket reads one request.
func (r TicketRepo) Ticket(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Ticket, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Ticket{}, err
	}
	ticketID, err := uuid.Parse(id)
	if err != nil {
		return domain.Ticket{}, notFound()
	}

	row, err := r.queries(ctx).GetTicket(ctx, sqlcgen.GetTicketParams{
		TenantID: tenantID, TicketID: ticketID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Ticket{}, notFound()
	}
	if err != nil {
		return domain.Ticket{}, err
	}
	return ticketFrom(row)
}

// UpdateTicket writes progress on a request.
func (r TicketRepo) UpdateTicket(ctx context.Context,
	scope authctx.TenantScope, t domain.Ticket, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ticketID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	parts, err := encode(t.Parts)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateTicket(ctx, sqlcgen.UpdateTicketParams{
		TenantID: tenantID, TicketID: ticketID,
		State: string(t.State), OwnerID: t.OwnerID,
		Diagnosis: t.Diagnosis, WorkPerformed: t.WorkPerformed, Parts: parts,
		DownUntil:            stamp(t.DownUntil),
		AwaitingPartsMinutes: int32(t.AwaitingPartsMinutes),
		RespondedAt:          stamp(t.RespondedAt),
		ResolvedAt:           stamp(t.ResolvedAt),
		ClosedAt:             stamp(t.ClosedAt), ClosedBy: t.ClosedBy,
		ClosureNote: t.ClosureNote, CancelledReason: t.CancelledReason,
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

// Tickets lists requests, most recent first.
func (r TicketRepo) Tickets(ctx context.Context, scope authctx.TenantScope,
	assetID, state string, openOnly bool, limit int32) (
	[]domain.Ticket, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTickets(ctx, sqlcgen.ListTicketsParams{
		TenantID: tenantID, AssetID: assetID, State: state,
		OpenOnly: openOnly, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return ticketsFrom(rows)
}

// ForAssetBetween is what the reliability figures are computed over.
func (r TicketRepo) ForAssetBetween(ctx context.Context,
	scope authctx.TenantScope, assetID string, from, to time.Time,
	limit int32) ([]domain.Ticket, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTicketsForAssetBetween(ctx,
		sqlcgen.ListTicketsForAssetBetweenParams{
			TenantID: tenantID, AssetID: id,
			PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return ticketsFrom(rows)
}

// ClosedPlannedWork is what PM compliance is counted from.
func (r TicketRepo) ClosedPlannedWork(ctx context.Context,
	scope authctx.TenantScope, assetID string, from, to time.Time) (
	[]domain.Ticket, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListClosedPlannedWork(ctx,
		sqlcgen.ListClosedPlannedWorkParams{
			TenantID: tenantID, AssetID: id,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	return ticketsFrom(rows)
}

func ticketsFrom(rows []sqlcgen.BiomedicalTicket) ([]domain.Ticket, error) {
	out := make([]domain.Ticket, 0, len(rows))
	for _, row := range rows {
		ticket, err := ticketFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, ticket)
	}
	return out, nil
}

func ticketFrom(row sqlcgen.BiomedicalTicket) (domain.Ticket, error) {
	out := domain.Ticket{
		ID: row.TicketID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, Kind: domain.TicketKind(row.Kind),
		AssetID: row.AssetID.String(), PlanID: uuidString(row.PlanID),
		AssetTag: row.AssetTag, LocationID: row.LocationID,
		Symptom: row.Symptom, Priority: domain.Priority(row.Priority),
		Impact: domain.Impact(row.Impact),
		State:  domain.TicketState(row.State), OwnerID: row.OwnerID,
		RespondBy: timeOf(row.RespondBy), ResolveBy: timeOf(row.ResolveBy),
		ContractID: uuidString(row.ContractID),
		Diagnosis:  row.Diagnosis, WorkPerformed: row.WorkPerformed,
		DownFrom: timeOf(row.DownFrom), DownUntil: timeOf(row.DownUntil),
		AwaitingPartsMinutes: int(row.AwaitingPartsMinutes),
		RespondedAt:          timeOf(row.RespondedAt),
		ResolvedAt:           timeOf(row.ResolvedAt),
		ClosedAt:             timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureNote: row.ClosureNote, CancelledReason: row.CancelledReason,
		RaisedAt: timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		Version: row.Version,
	}
	if err := decode(row.Parts, &out.Parts); err != nil {
		return domain.Ticket{}, err
	}
	return out, nil
}

// NoticeRepo implements ports.NoticeRepository.
type NoticeRepo struct{ *Repository }

var _ ports.NoticeRepository = NoticeRepo{}

// InsertNotice records a recall or safety notice.
func (r NoticeRepo) InsertNotice(ctx context.Context,
	scope authctx.TenantScope, n domain.SafetyNotice) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	noticeID, err := uuid.Parse(n.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertSafetyNotice(ctx,
		sqlcgen.InsertSafetyNoticeParams{
			NoticeID: noticeID, TenantID: tenantID,
			Reference: n.Reference, Kind: string(n.Kind),
			Issuer: n.Issuer, Summary: n.Summary,
			Make: n.Make, Model: n.Model,
			SerialFrom: n.SerialFrom, SerialTo: n.SerialTo,
			AffectedUdi: n.AffectedUDI, HoldAffected: n.HoldAffected,
			RequiredAction: n.RequiredAction,
			DueBy:          stamp(n.DueBy), IssuedOn: stamp(n.IssuedOn),
			RaisedAt: stamp(n.RaisedAt), RaisedBy: n.RaisedBy,
		})
}

// Notice reads one safety notice.
func (r NoticeRepo) Notice(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.SafetyNotice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.SafetyNotice{}, err
	}
	noticeID, err := uuid.Parse(id)
	if err != nil {
		return domain.SafetyNotice{}, notFound()
	}

	row, err := r.queries(ctx).GetSafetyNotice(ctx,
		sqlcgen.GetSafetyNoticeParams{TenantID: tenantID, NoticeID: noticeID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.SafetyNotice{}, notFound()
	}
	if err != nil {
		return domain.SafetyNotice{}, err
	}
	return noticeFrom(row), nil
}

// CloseNotice ends a safety notice.
func (r NoticeRepo) CloseNotice(ctx context.Context,
	scope authctx.TenantScope, n domain.SafetyNotice,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	noticeID, err := uuid.Parse(n.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).CloseSafetyNotice(ctx,
		sqlcgen.CloseSafetyNoticeParams{
			TenantID: tenantID, NoticeID: noticeID,
			ClosedAt: stamp(n.ClosedAt), ClosedBy: n.ClosedBy,
			ClosureNote: n.ClosureNote, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Notices lists safety notices.
func (r NoticeRepo) Notices(ctx context.Context, scope authctx.TenantScope,
	openOnly bool, limit int32) ([]domain.SafetyNotice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListSafetyNotices(ctx,
		sqlcgen.ListSafetyNoticesParams{
			TenantID: tenantID, OpenOnly: openOnly, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.SafetyNotice, 0, len(rows))
	for _, row := range rows {
		out = append(out, noticeFrom(row))
	}
	return out, nil
}

func noticeFrom(row sqlcgen.BiomedicalSafetyNotice) domain.SafetyNotice {
	return domain.SafetyNotice{
		ID: row.NoticeID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Kind: domain.NoticeKind(row.Kind),
		Issuer: row.Issuer, Summary: row.Summary,
		Make: row.Make, Model: row.Model,
		SerialFrom: row.SerialFrom, SerialTo: row.SerialTo,
		AffectedUDI: row.AffectedUdi, HoldAffected: row.HoldAffected,
		RequiredAction: row.RequiredAction,
		DueBy:          timeOf(row.DueBy), IssuedOn: timeOf(row.IssuedOn),
		RaisedAt: timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureNote: row.ClosureNote, Version: row.Version,
	}
}

// InsertTasks writes a notice's per-asset task list.
func (r NoticeRepo) InsertTasks(ctx context.Context,
	scope authctx.TenantScope, tasks []domain.NoticeTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	queries := r.queries(ctx)
	for _, task := range tasks {
		taskID, err := uuid.Parse(task.ID)
		if err != nil {
			return notFound()
		}
		noticeID, err := uuid.Parse(task.NoticeID)
		if err != nil {
			return notFound()
		}
		assetID, err := uuid.Parse(task.AssetID)
		if err != nil {
			return notFound()
		}

		if err := queries.InsertNoticeTask(ctx, sqlcgen.InsertNoticeTaskParams{
			TaskID: taskID, TenantID: tenantID, NoticeID: noticeID,
			AssetID: assetID, AssetTag: task.AssetTag,
			State: string(task.State), Note: task.Note,
		}); err != nil {
			return err
		}
	}
	return nil
}

// Task reads one asset's response.
func (r NoticeRepo) Task(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.NoticeTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.NoticeTask{}, err
	}
	taskID, err := uuid.Parse(id)
	if err != nil {
		return domain.NoticeTask{}, notFound()
	}

	row, err := r.queries(ctx).GetNoticeTask(ctx, sqlcgen.GetNoticeTaskParams{
		TenantID: tenantID, TaskID: taskID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.NoticeTask{}, notFound()
	}
	if err != nil {
		return domain.NoticeTask{}, err
	}
	return taskFrom(row), nil
}

// UpdateTask records progress on one asset's response.
func (r NoticeRepo) UpdateTask(ctx context.Context, scope authctx.TenantScope,
	t domain.NoticeTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	taskID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateNoticeTask(ctx,
		sqlcgen.UpdateNoticeTaskParams{
			TenantID: tenantID, TaskID: taskID,
			State: string(t.State), Note: t.Note,
			CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// Tasks reads a notice's whole task list.
func (r NoticeRepo) Tasks(ctx context.Context, scope authctx.TenantScope,
	noticeID string) ([]domain.NoticeTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(noticeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListNoticeTasks(ctx,
		sqlcgen.ListNoticeTasksParams{TenantID: tenantID, NoticeID: id})
	if err != nil {
		return nil, err
	}
	return tasksFrom(rows), nil
}

// TasksForAsset answers "is this machine held under anything".
func (r NoticeRepo) TasksForAsset(ctx context.Context,
	scope authctx.TenantScope, assetID string) ([]domain.NoticeTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTasksForAsset(ctx,
		sqlcgen.ListTasksForAssetParams{TenantID: tenantID, AssetID: id})
	if err != nil {
		return nil, err
	}
	return tasksFrom(rows), nil
}

func tasksFrom(rows []sqlcgen.BiomedicalNoticeTask) []domain.NoticeTask {
	out := make([]domain.NoticeTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, taskFrom(row))
	}
	return out
}

func taskFrom(row sqlcgen.BiomedicalNoticeTask) domain.NoticeTask {
	return domain.NoticeTask{
		ID: row.TaskID.String(), TenantID: row.TenantID.String(),
		NoticeID: row.NoticeID.String(), AssetID: row.AssetID.String(),
		AssetTag: row.AssetTag, State: domain.TaskState(row.State),
		Note:        row.Note,
		CompletedAt: timeOf(row.CompletedAt), CompletedBy: row.CompletedBy,
	}
}
