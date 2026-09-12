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

// Policy, series and waitlist (SRS-SCH-005, SRS-SCH-006, SRS-SCH-013,
// SRS-SCH-015).

// PolicyRepo reads and writes the cancellation and teleconsult rules.
type PolicyRepo struct{ *Repository }

var _ ports.PolicyRepository = PolicyRepo{}

// Resolve returns the policy in force.
func (r PolicyRepo) Resolve(ctx context.Context, scope authctx.TenantScope,
	facilityID string) (domain.CancellationPolicy, domain.TeleconsultPolicy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CancellationPolicy{}, domain.TeleconsultPolicy{}, err
	}
	facility, err := optionalUUID(facilityID)
	if err != nil {
		return domain.CancellationPolicy{}, domain.TeleconsultPolicy{}, err
	}

	rows, err := r.queries(ctx).GetCancellationPolicy(ctx, sqlcgen.GetCancellationPolicyParams{
		TenantID: tenantID, FacilityID: facility,
	})
	if err != nil {
		return domain.CancellationPolicy{}, domain.TeleconsultPolicy{}, err
	}
	if len(rows) == 0 {
		// A tenant that has configured nothing still gets a defensible policy
		// rather than none: no notice at all would make every cancellation
		// timely and every attendance report meaningless.
		return domain.DefaultCancellationPolicy(), domain.DefaultTeleconsultPolicy(), nil
	}

	// Facility-specific rows sort first, so the first row is the most specific.
	row := rows[0]

	visitTypes := make([]domain.VisitType, 0, len(row.TeleconsultVisitTypes))
	for _, raw := range row.TeleconsultVisitTypes {
		visitTypes = append(visitTypes, domain.VisitType(raw))
	}

	return domain.CancellationPolicy{
			NoticeHours:           int(row.NoticeHours),
			RescheduleNoticeHours: int(row.RescheduleNoticeHours),
			MaxReschedules:        int(row.MaxReschedules),
			ChargeableWhenLate:    row.ChargeableWhenLate,
		}, domain.TeleconsultPolicy{
			Enabled:                  row.TeleconsultEnabled,
			AllowedVisitTypes:        visitTypes,
			RequireConfirmedIdentity: row.TeleconsultRequiresConfirmedIdentity,
		}, nil
}

// Set writes the policy for a facility, or tenant-wide when facilityID is empty.
func (r PolicyRepo) Set(ctx context.Context, scope authctx.TenantScope, facilityID string,
	cancellation domain.CancellationPolicy, teleconsult domain.TeleconsultPolicy,
	now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	facility, err := optionalUUID(facilityID)
	if err != nil {
		return err
	}

	visitTypes := make([]string, 0, len(teleconsult.AllowedVisitTypes))
	for _, v := range teleconsult.AllowedVisitTypes {
		visitTypes = append(visitTypes, string(v))
	}

	return r.queries(ctx).UpsertCancellationPolicy(ctx, sqlcgen.UpsertCancellationPolicyParams{
		PolicyID: uuid.New(), TenantID: tenantID, FacilityID: facility,
		NoticeHours:                          int32(cancellation.NoticeHours),
		RescheduleNoticeHours:                int32(cancellation.RescheduleNoticeHours),
		MaxReschedules:                       int32(cancellation.MaxReschedules),
		ChargeableWhenLate:                   cancellation.ChargeableWhenLate,
		TeleconsultEnabled:                   teleconsult.Enabled,
		TeleconsultVisitTypes:                visitTypes,
		TeleconsultRequiresConfirmedIdentity: teleconsult.RequireConfirmedIdentity,
		CreatedAt:                            timestamptz(now), UpdatedAt: timestamptz(now),
	})
}

// RecordOutcome captures what the policy made of a decision.
func (r PolicyRepo) RecordOutcome(ctx context.Context, scope authctx.TenantScope,
	appointmentID, kind string, outcome domain.CancellationOutcome,
	by, reason string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(appointmentID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPolicyOutcome(ctx, sqlcgen.InsertPolicyOutcomeParams{
		OutcomeID: uuid.New(), TenantID: tenantID, AppointmentID: id,
		Kind: kind, Timely: outcome.Timely,
		NoticeGivenMinutes:    int32(outcome.NoticeGiven.Minutes()),
		NoticeRequiredMinutes: int32(outcome.NoticeRequired.Minutes()),
		Chargeable:            outcome.Chargeable,
		DecidedBy:             by, DecidedAt: timestamptz(at), Reason: reason,
	})
}

// Outcomes returns the decisions recorded against an appointment.
func (r PolicyRepo) Outcomes(ctx context.Context, scope authctx.TenantScope,
	appointmentID string) ([]ports.PolicyOutcome, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(appointmentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPolicyOutcomes(ctx, sqlcgen.ListPolicyOutcomesParams{
		TenantID: tenantID, AppointmentID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]ports.PolicyOutcome, 0, len(rows))
	for _, row := range rows {
		out = append(out, ports.PolicyOutcome{
			Kind: row.Kind,
			Outcome: domain.CancellationOutcome{
				Timely:         row.Timely,
				NoticeGiven:    time.Duration(row.NoticeGivenMinutes) * time.Minute,
				NoticeRequired: time.Duration(row.NoticeRequiredMinutes) * time.Minute,
				Chargeable:     row.Chargeable,
			},
			DecidedBy: row.DecidedBy, DecidedAt: row.DecidedAt.Time.UTC(),
			Reason: row.Reason,
		})
	}
	return out, nil
}

// SeriesRepo persists recurring courses.
type SeriesRepo struct{ *Repository }

var _ ports.SeriesRepository = SeriesRepo{}

// Insert stores a series.
func (r SeriesRepo) Insert(ctx context.Context, scope authctx.TenantScope, s domain.Series) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	seriesID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Internal("SCH_SERIES_ID_INVALID", "series_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(s.PatientID)
	if err != nil {
		return rpcerr.Invalid("SCH_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	resourceID, err := uuid.Parse(s.ResourceID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertSeries(ctx, sqlcgen.InsertSeriesParams{
		SeriesID: seriesID, TenantID: tenantID, PatientID: patientID,
		ResourceID: resourceID, VisitType: string(s.VisitType),
		IntervalDays: int32(s.IntervalDays), Occurrences: int32(s.Occurrences),
		StartsAt: timestamptz(s.StartsAt), CreatedBy: s.CreatedBy,
		CreatedAt: timestamptz(s.CreatedAt),
	})
}

// Get reads one series.
func (r SeriesRepo) Get(ctx context.Context, scope authctx.TenantScope,
	seriesID string) (domain.Series, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Series{}, err
	}
	id, err := uuid.Parse(seriesID)
	if err != nil {
		return domain.Series{}, notFound()
	}

	row, err := r.queries(ctx).GetSeries(ctx, sqlcgen.GetSeriesParams{
		TenantID: tenantID, SeriesID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Series{}, notFound()
	}
	if err != nil {
		return domain.Series{}, err
	}

	return domain.Series{
		ID: row.SeriesID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), ResourceID: row.ResourceID.String(),
		VisitType:    domain.VisitType(row.VisitType),
		IntervalDays: int(row.IntervalDays), Occurrences: int(row.Occurrences),
		StartsAt: row.StartsAt.Time.UTC(), CreatedBy: row.CreatedBy,
		CreatedAt: row.CreatedAt.Time.UTC(), Cancelled: row.Cancelled,
	}, nil
}

// Appointments returns every occurrence of a series, in order.
func (r SeriesRepo) Appointments(ctx context.Context, scope authctx.TenantScope,
	seriesID string) ([]*domain.Appointment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(seriesID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListSeriesAppointments(ctx, sqlcgen.ListSeriesAppointmentsParams{
		TenantID: tenantID, SeriesID: pgtype.UUID{Bytes: id, Valid: true},
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

// Cancel abandons a series part-way.
func (r SeriesRepo) Cancel(ctx context.Context, scope authctx.TenantScope, seriesID string) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(seriesID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).CancelSeries(ctx, sqlcgen.CancelSeriesParams{
		TenantID: tenantID, SeriesID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// WaitlistRepo persists patients waiting for an earlier slot.
type WaitlistRepo struct{ *Repository }

var _ ports.WaitlistRepository = WaitlistRepo{}

// Insert adds a patient to the list.
func (r WaitlistRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	w domain.WaitlistEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	waitlistID, err := uuid.Parse(w.ID)
	if err != nil {
		return rpcerr.Internal("SCH_WAITLIST_ID_INVALID", "waitlist_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(w.PatientID)
	if err != nil {
		return rpcerr.Invalid("SCH_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	resource, err := optionalUUID(w.ResourceID)
	if err != nil {
		return err
	}
	facility, err := optionalUUID(w.FacilityID)
	if err != nil {
		return err
	}
	orgUnit, err := optionalUUID(w.OrgUnitID)
	if err != nil {
		return err
	}
	appointment, err := optionalUUID(w.AppointmentID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertWaitlistEntry(ctx, sqlcgen.InsertWaitlistEntryParams{
		WaitlistID: waitlistID, TenantID: tenantID, PatientID: patientID,
		ResourceID: resource, FacilityID: facility, OrgUnitID: orgUnit,
		VisitType: string(w.VisitType),
		NotBefore: nullableTimestamptz(w.NotBefore), NotAfter: nullableTimestamptz(w.NotAfter),
		AppointmentID: appointment, Status: string(w.Status),
		CreatedBy: w.CreatedBy, CreatedAt: timestamptz(w.CreatedAt),
		UpdatedAt: timestamptz(w.UpdatedAt),
	})
}

// nullableTimestamptz renders the zero time as SQL NULL.
func nullableTimestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return timestamptz(t)
}

// Get reads one waitlist entry.
func (r WaitlistRepo) Get(ctx context.Context, scope authctx.TenantScope,
	waitlistID string) (domain.WaitlistEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.WaitlistEntry{}, err
	}
	id, err := uuid.Parse(waitlistID)
	if err != nil {
		return domain.WaitlistEntry{}, notFound()
	}

	row, err := r.queries(ctx).GetWaitlistEntry(ctx, sqlcgen.GetWaitlistEntryParams{
		TenantID: tenantID, WaitlistID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.WaitlistEntry{}, notFound()
	}
	if err != nil {
		return domain.WaitlistEntry{}, err
	}
	return waitlistFromRow(sqlcgen.SchedulingWaitlistEntry(row)), nil
}

// Open returns the list a scheduler works when a slot frees up.
func (r WaitlistRepo) Open(ctx context.Context, scope authctx.TenantScope,
	resourceID string, limit int32) ([]domain.WaitlistEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	resource, err := optionalUUID(resourceID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOpenWaitlistEntries(ctx, sqlcgen.ListOpenWaitlistEntriesParams{
		TenantID: tenantID, ResourceID: resource, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.WaitlistEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, waitlistFromRow(sqlcgen.SchedulingWaitlistEntry(row)))
	}
	return out, nil
}

// Update writes the entry back, guarded on the status the caller read.
func (r WaitlistRepo) Update(ctx context.Context, scope authctx.TenantScope,
	w domain.WaitlistEntry, expected domain.WaitlistStatus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(w.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateWaitlistEntry(ctx, sqlcgen.UpdateWaitlistEntryParams{
		TenantID: tenantID, WaitlistID: id, Status: string(w.Status),
		OfferedSlotAt:  nullableTimestamptz(w.OfferedSlotAt),
		OfferExpiresAt: nullableTimestamptz(w.OfferExpiresAt),
		UpdatedAt:      timestamptz(w.UpdatedAt),
		ExpectedStatus: string(expected),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Guarded on the status read: two schedulers offering the same slot to
		// the same patient would otherwise both write, and the second would
		// replace the first one's offer with an expiry the patient never saw.
		return ports.ErrVersionConflict
	}
	return nil
}

// ExpireStale returns unanswered offers to the waiting list.
func (r WaitlistRepo) ExpireStale(ctx context.Context, scope authctx.TenantScope,
	now time.Time) (int64, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	return r.queries(ctx).ExpireStaleOffers(ctx, sqlcgen.ExpireStaleOffersParams{
		TenantID: tenantID, Now: timestamptz(now), UpdatedAt: timestamptz(now),
	})
}

func waitlistFromRow(row sqlcgen.SchedulingWaitlistEntry) domain.WaitlistEntry {
	w := domain.WaitlistEntry{
		ID: row.WaitlistID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), VisitType: domain.VisitType(row.VisitType),
		Status:    domain.WaitlistStatus(row.Status),
		CreatedBy: row.CreatedBy, CreatedAt: row.CreatedAt.Time.UTC(),
		UpdatedAt: row.UpdatedAt.Time.UTC(),
	}
	if row.ResourceID.Valid {
		w.ResourceID = uuid.UUID(row.ResourceID.Bytes).String()
	}
	if row.FacilityID.Valid {
		w.FacilityID = uuid.UUID(row.FacilityID.Bytes).String()
	}
	if row.OrgUnitID.Valid {
		w.OrgUnitID = uuid.UUID(row.OrgUnitID.Bytes).String()
	}
	if row.AppointmentID.Valid {
		w.AppointmentID = uuid.UUID(row.AppointmentID.Bytes).String()
	}
	if row.NotBefore.Valid {
		w.NotBefore = row.NotBefore.Time.UTC()
	}
	if row.NotAfter.Valid {
		w.NotAfter = row.NotAfter.Time.UTC()
	}
	if row.OfferedSlotAt.Valid {
		w.OfferedSlotAt = row.OfferedSlotAt.Time.UTC()
	}
	if row.OfferExpiresAt.Valid {
		w.OfferExpiresAt = row.OfferExpiresAt.Time.UTC()
	}
	return w
}

// SetRescheduleCount carries a reschedule count forward across a chain.
func (r AppointmentRepo) SetRescheduleCount(ctx context.Context, scope authctx.TenantScope,
	appointmentID string, count int, expectedVersion int64, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(appointmentID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetAppointmentRescheduled(ctx,
		sqlcgen.SetAppointmentRescheduledParams{
			TenantID: tenantID, AppointmentID: id,
			RescheduleCount: int32(count), UpdatedAt: timestamptz(at),
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

var _ ports.RescheduleRecorder = AppointmentRepo{}
