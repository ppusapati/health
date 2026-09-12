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

// Rosters, exceptions and consumed capacity (SRS-SCH-001 … 004).

// ScheduleRepo persists availability rules.
type ScheduleRepo struct{ *Repository }

var _ ports.ScheduleRepository = ScheduleRepo{}

// InsertSchedule stores an availability rule.
func (r ScheduleRepo) InsertSchedule(ctx context.Context, scope authctx.TenantScope,
	s domain.Schedule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	scheduleID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Internal("SCH_SCHEDULE_ID_INVALID", "schedule_id must be a UUID").WithCause(err)
	}
	resourceID, err := uuid.Parse(s.ResourceID)
	if err != nil {
		return notFound()
	}
	facilityID, err := uuid.Parse(s.FacilityID)
	if err != nil {
		return rpcerr.Internal("SCH_FACILITY_ID_INVALID", "facility_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).InsertSchedule(ctx, sqlcgen.InsertScheduleParams{
		ScheduleID: scheduleID, TenantID: tenantID, ResourceID: resourceID,
		FacilityID: facilityID, VisitType: string(s.VisitType),
		VisitMode: string(s.VisitMode), Weekday: int16(s.Weekday),
		StartMinute: int32(s.StartMinute), EndMinute: int32(s.EndMinute),
		SlotMinutes: int32(s.SlotMinutes), Capacity: int32(s.Capacity),
		EffectiveFrom: date(s.EffectiveFrom), EffectiveUntil: dateOrNull(s.EffectiveUntil),
		CreatedAt: timestamptz(s.CreatedAt), UpdatedAt: timestamptz(s.UpdatedAt),
	})
}

// SchedulesFor returns every rule that could be in force over a date range.
func (r ScheduleRepo) SchedulesFor(ctx context.Context, scope authctx.TenantScope,
	resourceIDs []string, visitType domain.VisitType, from, until time.Time) ([]domain.Schedule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	ids := parseIDs(resourceIDs)
	if len(ids) == 0 {
		return nil, nil
	}

	rows, err := r.queries(ctx).ListSchedulesForResources(ctx, sqlcgen.ListSchedulesForResourcesParams{
		TenantID: tenantID, ResourceIds: ids,
		FromDate: date(from), UntilDate: date(until),
		VisitType: string(visitType),
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Schedule, 0, len(rows))
	for _, row := range rows {
		out = append(out, scheduleFromRow(sqlcgen.SchedulingSchedule(row)))
	}
	return out, nil
}

// EndSchedule closes a rule that has already taken effect.
func (r ScheduleRepo) EndSchedule(ctx context.Context, scope authctx.TenantScope,
	scheduleID string, until time.Time, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(scheduleID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).EndSchedule(ctx, sqlcgen.EndScheduleParams{
		TenantID: tenantID, ScheduleID: id,
		EffectiveUntil: dateOrNull(until), UpdatedAt: timestamptz(at),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// DeleteSchedule removes a rule that never took effect.
func (r ScheduleRepo) DeleteSchedule(ctx context.Context, scope authctx.TenantScope,
	scheduleID string, today time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(scheduleID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).DeleteSchedule(ctx, sqlcgen.DeleteScheduleParams{
		TenantID: tenantID, ScheduleID: id, Today: date(today),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// The statement is guarded on the rule not having taken effect, so no
		// rows means it has. Deleting it would orphan the appointments it
		// produced, which are real whatever the roster now says.
		return rpcerr.FailedPrecondition("SCH_SCHEDULE_IN_EFFECT",
			"this roster has already taken effect; end it rather than deleting it")
	}
	return nil
}

// InsertException stores a blocked period.
func (r ScheduleRepo) InsertException(ctx context.Context, scope authctx.TenantScope,
	e domain.Exception) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	exceptionID, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Internal("SCH_EXCEPTION_ID_INVALID", "exception_id must be a UUID").WithCause(err)
	}
	resourceID, err := uuid.Parse(e.ResourceID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertException(ctx, sqlcgen.InsertExceptionParams{
		ExceptionID: exceptionID, TenantID: tenantID, ResourceID: resourceID,
		Kind: string(e.Kind), StartsAt: timestamptz(e.StartsAt), EndsAt: timestamptz(e.EndsAt),
		Reason: e.Reason, Overridable: e.Overridable,
		CreatedBy: e.CreatedBy, CreatedAt: timestamptz(e.CreatedAt),
	})
}

// ExceptionsFor returns the blocked periods overlapping a window.
func (r ScheduleRepo) ExceptionsFor(ctx context.Context, scope authctx.TenantScope,
	resourceIDs []string, from, until time.Time) ([]domain.Exception, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	ids := parseIDs(resourceIDs)
	if len(ids) == 0 {
		return nil, nil
	}

	rows, err := r.queries(ctx).ListExceptionsForResources(ctx,
		sqlcgen.ListExceptionsForResourcesParams{
			TenantID: tenantID, ResourceIds: ids,
			FromAt: timestamptz(from), UntilAt: timestamptz(until),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Exception, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Exception{
			ID: row.ExceptionID.String(), TenantID: row.TenantID.String(),
			ResourceID: row.ResourceID.String(), Kind: domain.ExceptionKind(row.Kind),
			StartsAt: row.StartsAt.Time.UTC(), EndsAt: row.EndsAt.Time.UTC(),
			Reason: row.Reason, Overridable: row.Overridable,
			CreatedBy: row.CreatedBy, CreatedAt: row.CreatedAt.Time.UTC(),
		})
	}
	return out, nil
}

// DeleteException removes a blocked period.
func (r ScheduleRepo) DeleteException(ctx context.Context, scope authctx.TenantScope,
	exceptionID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(exceptionID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).DeleteException(ctx, sqlcgen.DeleteExceptionParams{
		TenantID: tenantID, ExceptionID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

func scheduleFromRow(row sqlcgen.SchedulingSchedule) domain.Schedule {
	s := domain.Schedule{
		ID: row.ScheduleID.String(), TenantID: row.TenantID.String(),
		ResourceID: row.ResourceID.String(), FacilityID: row.FacilityID.String(),
		VisitType: domain.VisitType(row.VisitType), VisitMode: domain.VisitMode(row.VisitMode),
		Weekday:     time.Weekday(row.Weekday),
		StartMinute: int(row.StartMinute), EndMinute: int(row.EndMinute),
		SlotMinutes: int(row.SlotMinutes), Capacity: int(row.Capacity),
		EffectiveFrom: row.EffectiveFrom.Time.UTC(),
		CreatedAt:     row.CreatedAt.Time.UTC(), UpdatedAt: row.UpdatedAt.Time.UTC(),
	}
	if row.EffectiveUntil.Valid {
		s.EffectiveUntil = row.EffectiveUntil.Time.UTC()
	}
	return s
}

// SlotRepo owns consumed capacity (SRS-SCH-004).
type SlotRepo struct{ *Repository }

var _ ports.SlotRepository = SlotRepo{}

// ClaimCapacity materialises the slot if needed and takes one unit, atomically.
//
// Two statements, one call, both inside the caller's transaction. The insert is
// ON CONFLICT DO NOTHING so two concurrent first bookings converge on one row;
// the update is guarded on booked < capacity so only one of them gets the last
// unit. Splitting these across two port methods would have let a caller
// interleave them and put the race back.
func (r SlotRepo) ClaimCapacity(ctx context.Context, scope authctx.TenantScope,
	slot domain.Slot, slotID string, at time.Time) (string, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return "", err
	}
	newID, err := uuid.Parse(slotID)
	if err != nil {
		return "", rpcerr.Internal("SCH_SLOT_ID_INVALID", "slot_id must be a UUID").WithCause(err)
	}
	resourceID, err := uuid.Parse(slot.ResourceID)
	if err != nil {
		return "", notFound()
	}

	q := r.queries(ctx)
	if err := q.EnsureSlot(ctx, sqlcgen.EnsureSlotParams{
		SlotID: newID, TenantID: tenantID, ResourceID: resourceID,
		StartsAt: timestamptz(slot.StartsAt), EndsAt: timestamptz(slot.EndsAt),
		VisitType: string(slot.VisitType), Capacity: int32(slot.Capacity),
		CreatedAt: timestamptz(at), UpdatedAt: timestamptz(at),
	}); err != nil {
		return "", err
	}

	claimed, err := q.ClaimSlotCapacity(ctx, sqlcgen.ClaimSlotCapacityParams{
		TenantID: tenantID, ResourceID: resourceID,
		StartsAt: timestamptz(slot.StartsAt), VisitType: string(slot.VisitType),
		UpdatedAt: timestamptz(at),
	})
	if errors.Is(err, pgx.ErrNoRows) {
		// No row matched the guarded predicate, which means the slot is full.
		// This is the only trustworthy signal: a count read beforehand is stale
		// by the time the update runs.
		return "", ports.ErrSlotFull
	}
	if err != nil {
		return "", err
	}
	return claimed.SlotID.String(), nil
}

// ReleaseCapacity gives one unit back on cancellation.
func (r SlotRepo) ReleaseCapacity(ctx context.Context, scope authctx.TenantScope,
	slotID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(slotID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ReleaseSlotCapacity(ctx, sqlcgen.ReleaseSlotCapacityParams{
		TenantID: tenantID, SlotID: id, UpdatedAt: timestamptz(at),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Guarded on booked > 0, so no rows means the counter was already at
		// zero. Silently succeeding would let a double cancellation hand the
		// clinic capacity it does not have.
		return rpcerr.FailedPrecondition("SCH_SLOT_NOT_BOOKED",
			"that slot has no booking to release")
	}
	return nil
}

// BookedCounts reports consumed capacity across a window.
func (r SlotRepo) BookedCounts(ctx context.Context, scope authctx.TenantScope,
	resourceIDs []string, from, until time.Time) (map[domain.SlotKey]int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	ids := parseIDs(resourceIDs)
	if len(ids) == 0 {
		return map[domain.SlotKey]int{}, nil
	}

	rows, err := r.queries(ctx).CountBookedSlots(ctx, sqlcgen.CountBookedSlotsParams{
		TenantID: tenantID, ResourceIds: ids,
		FromAt: timestamptz(from), UntilAt: timestamptz(until),
	})
	if err != nil {
		return nil, err
	}

	out := make(map[domain.SlotKey]int, len(rows))
	for _, row := range rows {
		out[domain.SlotKey{
			ResourceID: row.ResourceID.String(),
			StartsAt:   row.StartsAt.Time.UTC(),
			VisitType:  domain.VisitType(row.VisitType),
		}] = int(row.Booked)
	}
	return out, nil
}
