package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Check-in, the queue and notifications (SRS-SCH-007 … SRS-SCH-012).

// SetCheckIn records arrival and the queue position it produced.
func (r AppointmentRepo) SetCheckIn(ctx context.Context, scope authctx.TenantScope,
	a *domain.Appointment, change domain.StatusChange, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	appointmentID, err := uuid.Parse(a.ID())
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	rows, err := q.SetCheckIn(ctx, sqlcgen.SetCheckInParams{
		TenantID: tenantID, AppointmentID: appointmentID,
		Status: string(a.Status), Token: a.Token,
		ArrivalMode: string(a.ArrivalMode),
		CheckedInAt: nullableTimestamptzPtr(a.CheckedInAt),
		Priority:    string(a.Priority), PriorityReason: a.PriorityReason,
		UpdatedAt: timestamptz(a.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Two clerks checking in the same patient at once would otherwise both
		// write, and the second would issue a token the board never showed.
		return ports.ErrVersionConflict
	}
	a.Version = expectedVersion + 1

	return r.appendHistory(ctx, q, tenantID, appointmentID, change)
}

// SetPriority moves a patient in the queue.
func (r AppointmentRepo) SetPriority(ctx context.Context, scope authctx.TenantScope,
	a *domain.Appointment, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	appointmentID, err := uuid.Parse(a.ID())
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetPriority(ctx, sqlcgen.SetPriorityParams{
		TenantID: tenantID, AppointmentID: appointmentID,
		Priority: string(a.Priority), PriorityReason: a.PriorityReason,
		UpdatedAt: timestamptz(a.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	a.Version = expectedVersion + 1
	return nil
}

// Queue returns everyone checked in at a facility over a window.
func (r AppointmentRepo) Queue(ctx context.Context, scope authctx.TenantScope,
	facilityID, resourceID string, from, until time.Time, limit int32) (
	[]*domain.Appointment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := uuid.Parse(facilityID)
	if err != nil {
		return nil, notFound()
	}
	resource, err := optionalUUID(resourceID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListQueue(ctx, sqlcgen.ListQueueParams{
		TenantID: tenantID, FacilityID: facility, ResourceID: resource,
		FromAt: timestamptz(from), UntilAt: timestamptz(until), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Appointment, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, appointmentFromRow(sqlcgen.SchedulingAppointment(row)))
		ids = append(ids, row.AppointmentID)
	}

	// The history comes with the queue. The wait estimate is computed from
	// consultations that actually finished (SRS-SCH-009), and that lives in the
	// status history — a queue returned without it would make every estimate
	// fall back to the roster for ever, which is the one thing the requirement
	// exists to avoid.
	if err := r.attachHistory(ctx, tenantID, ids, out); err != nil {
		return nil, err
	}
	return out, nil
}

// attachHistory loads the status history of a batch of appointments.
func (r AppointmentRepo) attachHistory(ctx context.Context, tenantID uuid.UUID,
	ids []uuid.UUID, appointments []*domain.Appointment) error {

	if len(ids) == 0 {
		return nil
	}

	rows, err := r.queries(ctx).ListStatusHistoryForMany(ctx,
		sqlcgen.ListStatusHistoryForManyParams{TenantID: tenantID, AppointmentIds: ids})
	if err != nil {
		return err
	}

	byAppointment := make(map[string][]domain.StatusChange, len(ids))
	for _, row := range rows {
		key := row.AppointmentID.String()
		byAppointment[key] = append(byAppointment[key], domain.StatusChange{
			From: domain.Status(row.FromStatus), To: domain.Status(row.ToStatus),
			At: row.ChangedAt.Time.UTC(), By: row.ChangedBy,
			Reason: row.Reason, Corrected: row.Corrected,
		})
	}
	for _, a := range appointments {
		a.History = byAppointment[a.ID()]
	}
	return nil
}

// NextQueueNumber issues the next number for a facility on a local date.
func (r AppointmentRepo) NextQueueNumber(ctx context.Context, scope authctx.TenantScope,
	facilityID string, day time.Time, at time.Time) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	facility, err := uuid.Parse(facilityID)
	if err != nil {
		return 0, notFound()
	}

	issued, err := r.queries(ctx).NextQueueNumber(ctx, sqlcgen.NextQueueNumberParams{
		TenantID: tenantID, FacilityID: facility,
		QueueDate: pgtype.Date{Time: day, Valid: true},
		UpdatedAt: timestamptz(at),
	})
	if err != nil {
		return 0, err
	}
	return int(issued), nil
}

var _ ports.QueueRepository = AppointmentRepo{}

// NotificationRepo records what was sent and what came back (SRS-SCH-012).
type NotificationRepo struct{ *Repository }

var _ ports.NotificationRepository = NotificationRepo{}

// Insert stores a message record.
func (r NotificationRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	n domain.Notification) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	notificationID, err := uuid.Parse(n.ID)
	if err != nil {
		return rpcerr.Internal("SCH_NOTIFICATION_ID_INVALID",
			"notification_id must be a UUID").WithCause(err)
	}
	appointmentID, err := optionalUUID(n.AppointmentID)
	if err != nil {
		return err
	}
	waitlistID, err := optionalUUID(n.WaitlistID)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(n.PatientID)
	if err != nil {
		return rpcerr.Invalid("SCH_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}

	return r.queries(ctx).InsertNotification(ctx, sqlcgen.InsertNotificationParams{
		NotificationID: notificationID, TenantID: tenantID,
		AppointmentID: appointmentID, WaitlistID: waitlistID, PatientID: patientID,
		Kind: string(n.Kind), Channel: n.Channel,
		Outcome: string(n.Outcome), Detail: n.Detail,
		SendAfter: nullableTimestamptz(n.SendAfter),
		CreatedAt: timestamptz(n.CreatedAt), UpdatedAt: timestamptz(n.UpdatedAt),
	})
}

// Get reads one notification.
func (r NotificationRepo) Get(ctx context.Context, scope authctx.TenantScope,
	notificationID string) (domain.Notification, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Notification{}, err
	}
	id, err := uuid.Parse(notificationID)
	if err != nil {
		return domain.Notification{}, notFound()
	}

	row, err := r.queries(ctx).GetNotification(ctx, sqlcgen.GetNotificationParams{
		TenantID: tenantID, NotificationID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Notification{}, notFound()
	}
	if err != nil {
		return domain.Notification{}, err
	}
	return notificationFromRow(sqlcgen.SchedulingAppointmentNotification(row)), nil
}

// Resolve records what the channel reported back.
func (r NotificationRepo) Resolve(ctx context.Context, scope authctx.TenantScope,
	n domain.Notification) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(n.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ResolveNotification(ctx, sqlcgen.ResolveNotificationParams{
		TenantID: tenantID, NotificationID: id,
		Outcome: string(n.Outcome), Detail: n.Detail, UpdatedAt: timestamptz(n.UpdatedAt),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Guarded on still being pending: a late callback for a message already
		// resolved must not overwrite the outcome somebody has already read.
		return rpcerr.FailedPrecondition("SCH_NOTIFICATION_ALREADY_RESOLVED",
			"that message already has an outcome")
	}
	return nil
}

// ForSubject returns every message sent about one appointment or one offer.
func (r NotificationRepo) ForSubject(ctx context.Context, scope authctx.TenantScope,
	subject domain.NotificationSubject) ([]domain.Notification, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	appointmentID, err := optionalUUID(subject.AppointmentID)
	if err != nil {
		return nil, err
	}
	waitlistID, err := optionalUUID(subject.WaitlistID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListNotifications(ctx, sqlcgen.ListNotificationsParams{
		TenantID: tenantID, AppointmentID: appointmentID, WaitlistID: waitlistID,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Notification, 0, len(rows))
	for _, row := range rows {
		out = append(out, notificationFromRow(sqlcgen.SchedulingAppointmentNotification(row)))
	}
	return out, nil
}

// Pending returns the messages due to go out.
func (r NotificationRepo) Pending(ctx context.Context, scope authctx.TenantScope,
	now time.Time, limit int32) ([]domain.Notification, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListPendingNotifications(ctx,
		sqlcgen.ListPendingNotificationsParams{
			TenantID: tenantID, Now: timestamptz(now), PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Notification, 0, len(rows))
	for _, row := range rows {
		out = append(out, notificationFromRow(sqlcgen.SchedulingAppointmentNotification(row)))
	}
	return out, nil
}

func notificationFromRow(row sqlcgen.SchedulingAppointmentNotification) domain.Notification {
	n := domain.Notification{
		ID: row.NotificationID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(),
		Kind:      domain.NotificationKind(row.Kind), Channel: row.Channel,
		Outcome: domain.DeliveryOutcome(row.Outcome), Detail: row.Detail,
		CreatedAt: row.CreatedAt.Time.UTC(), UpdatedAt: row.UpdatedAt.Time.UTC(),
	}
	if row.AppointmentID.Valid {
		n.AppointmentID = uuid.UUID(row.AppointmentID.Bytes).String()
	}
	if row.WaitlistID.Valid {
		n.WaitlistID = uuid.UUID(row.WaitlistID.Bytes).String()
	}
	if row.SendAfter.Valid {
		n.SendAfter = row.SendAfter.Time.UTC()
	}
	return n
}
