package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Appointments and their status history (SRS-SCH-004, SRS-SCH-005, SRS-SCH-008).

// AppointmentRepo persists bookings.
type AppointmentRepo struct{ *Repository }

var _ ports.AppointmentRepository = AppointmentRepo{}

// Insert stores a booking and its first history entry.
func (r AppointmentRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	a *domain.Appointment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	appointmentID, err := uuid.Parse(a.ID())
	if err != nil {
		return rpcerr.Internal("SCH_APPOINTMENT_ID_INVALID",
			"appointment_id must be a UUID").WithCause(err)
	}
	facilityID, err := uuid.Parse(a.FacilityID)
	if err != nil {
		return rpcerr.Internal("SCH_FACILITY_ID_INVALID", "facility_id must be a UUID").WithCause(err)
	}
	resourceID, err := uuid.Parse(a.ResourceID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return rpcerr.Invalid("SCH_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	slotID, err := uuid.Parse(a.SlotID)
	if err != nil {
		return rpcerr.Internal("SCH_SLOT_ID_INVALID", "slot_id must be a UUID").WithCause(err)
	}
	orgUnit, err := optionalUUID(a.OrgUnitID)
	if err != nil {
		return err
	}
	rescheduledFrom, err := optionalUUID(a.RescheduledFromID)
	if err != nil {
		return err
	}
	seriesID, err := optionalUUID(a.SeriesID)
	if err != nil {
		return err
	}
	var occurrence *int32
	if a.Occurrence > 0 {
		position := int32(a.Occurrence)
		occurrence = &position
	}

	q := r.queries(ctx)
	if err := q.InsertAppointment(ctx, sqlcgen.InsertAppointmentParams{
		AppointmentID: appointmentID, TenantID: tenantID, FacilityID: facilityID,
		ResourceID: resourceID, OrgUnitID: orgUnit, PatientID: patientID, SlotID: slotID,
		VisitType: string(a.VisitType), VisitMode: string(a.VisitMode),
		StartsAt: timestamptz(a.StartsAt), EndsAt: timestamptz(a.EndsAt),
		Status: string(a.Status), BookedBy: a.BookedBy, Reason: a.Reason,
		RescheduledFromID: rescheduledFrom,
		SeriesID:          seriesID, Occurrence: occurrence,
		RescheduleCount: int32(a.RescheduleCount), JoinUrl: a.JoinURL,
		CreatedAt: timestamptz(a.CreatedAt), UpdatedAt: timestamptz(a.UpdatedAt),
	}); err != nil {
		return err
	}

	// The history entries the aggregate was constructed with, in the same
	// transaction. An appointment whose history did not survive its own insert
	// would be one nobody could explain later.
	for _, change := range a.History {
		if err := r.appendHistory(ctx, q, tenantID, appointmentID, change); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one appointment with its history.
func (r AppointmentRepo) Get(ctx context.Context, scope authctx.TenantScope,
	appointmentID string) (*domain.Appointment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(appointmentID)
	if err != nil {
		return nil, notFound()
	}

	row, err := r.queries(ctx).GetAppointment(ctx, sqlcgen.GetAppointmentParams{
		TenantID: tenantID, AppointmentID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}

	a := appointmentFromRow(sqlcgen.SchedulingAppointment(row))
	history, err := r.History(ctx, scope, appointmentID)
	if err != nil {
		return nil, err
	}
	a.History = history
	return a, nil
}

// SetStatus writes the new status and appends its history entry.
func (r AppointmentRepo) SetStatus(ctx context.Context, scope authctx.TenantScope,
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
	rows, err := q.SetAppointmentStatus(ctx, sqlcgen.SetAppointmentStatusParams{
		TenantID: tenantID, AppointmentID: appointmentID,
		Status: string(a.Status), UpdatedAt: timestamptz(a.UpdatedAt),
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Guarded on version: two clerks checking in the same patient at once
		// would otherwise both write, and the second would overwrite a status
		// it never saw.
		return ports.ErrVersionConflict
	}
	a.Version = expectedVersion + 1

	return r.appendHistory(ctx, q, tenantID, appointmentID, change)
}

func (r AppointmentRepo) appendHistory(ctx context.Context, q *sqlcgen.Queries,
	tenantID, appointmentID uuid.UUID, change domain.StatusChange) error {

	return q.InsertStatusHistory(ctx, sqlcgen.InsertStatusHistoryParams{
		HistoryID: uuid.New(), TenantID: tenantID, AppointmentID: appointmentID,
		FromStatus: string(change.From), ToStatus: string(change.To),
		ChangedAt: timestamptz(change.At), ChangedBy: change.By,
		Reason: change.Reason, Corrected: change.Corrected,
	})
}

// History returns every status the appointment has held.
func (r AppointmentRepo) History(ctx context.Context, scope authctx.TenantScope,
	appointmentID string) ([]domain.StatusChange, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(appointmentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListStatusHistory(ctx, sqlcgen.ListStatusHistoryParams{
		TenantID: tenantID, AppointmentID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.StatusChange, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.StatusChange{
			From: domain.Status(row.FromStatus), To: domain.Status(row.ToStatus),
			At: row.ChangedAt.Time.UTC(), By: row.ChangedBy,
			Reason: row.Reason, Corrected: row.Corrected,
		})
	}
	return out, nil
}

// ForPatient returns a patient's appointments, newest first.
func (r AppointmentRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) ([]*domain.Appointment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAppointmentsForPatient(ctx,
		sqlcgen.ListAppointmentsForPatientParams{
			TenantID: tenantID, PatientID: id, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Appointment, 0, len(rows))
	for _, row := range rows {
		out = append(out, appointmentFromRow(sqlcgen.SchedulingAppointment(row)))
	}
	return out, nil
}

// ForDay returns the clinic list.
func (r AppointmentRepo) ForDay(ctx context.Context, scope authctx.TenantScope,
	facilityID, resourceID string, from, until time.Time, limit int32) ([]*domain.Appointment, error) {

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

	rows, err := r.queries(ctx).ListAppointmentsForDay(ctx, sqlcgen.ListAppointmentsForDayParams{
		TenantID: tenantID, FacilityID: facility, ResourceID: resource,
		FromAt: timestamptz(from), UntilAt: timestamptz(until), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Appointment, 0, len(rows))
	for _, row := range rows {
		out = append(out, appointmentFromRow(sqlcgen.SchedulingAppointment(row)))
	}
	return out, nil
}

func appointmentFromRow(row sqlcgen.SchedulingAppointment) *domain.Appointment {
	a := domain.Appointment{
		TenantID: row.TenantID.String(), FacilityID: row.FacilityID.String(),
		ResourceID: row.ResourceID.String(), PatientID: row.PatientID.String(),
		SlotID:    row.SlotID.String(),
		VisitType: domain.VisitType(row.VisitType), VisitMode: domain.VisitMode(row.VisitMode),
		StartsAt: row.StartsAt.Time.UTC(), EndsAt: row.EndsAt.Time.UTC(),
		Status:   domain.Status(row.Status),
		BookedBy: row.BookedBy, Reason: row.Reason,
		CreatedAt: row.CreatedAt.Time.UTC(), UpdatedAt: row.UpdatedAt.Time.UTC(),
		Version:         row.Version,
		RescheduleCount: int(row.RescheduleCount), JoinURL: row.JoinUrl,
	}
	if row.OrgUnitID.Valid {
		a.OrgUnitID = uuid.UUID(row.OrgUnitID.Bytes).String()
	}
	if row.RescheduledFromID.Valid {
		a.RescheduledFromID = uuid.UUID(row.RescheduledFromID.Bytes).String()
	}
	if row.SeriesID.Valid {
		a.SeriesID = uuid.UUID(row.SeriesID.Bytes).String()
	}
	if row.Occurrence != nil {
		a.Occurrence = int(*row.Occurrence)
	}
	return domain.RestoreAppointment(row.AppointmentID.String(), a)
}
