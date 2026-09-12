-- Scheduling: resources, rosters, slots and appointments (SRS-SCH).

-- name: InsertResource :exec
INSERT INTO scheduling.resource (
    resource_id, tenant_id, facility_id, org_unit_id, resource_type,
    subject_id, display_name, status, time_zone, created_at, updated_at
) VALUES (
    @resource_id, @tenant_id, @facility_id, sqlc.narg('org_unit_id')::uuid,
    @resource_type, @subject_id, @display_name, @status, @time_zone,
    @created_at, @updated_at
);

-- name: GetResource :one
SELECT resource_id, tenant_id, facility_id, org_unit_id, resource_type,
       subject_id, display_name, status, time_zone, created_at, updated_at
FROM scheduling.resource
WHERE tenant_id = @tenant_id AND resource_id = @resource_id;

-- name: SetResourceStatus :execrows
UPDATE scheduling.resource
SET status = @status, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND resource_id = @resource_id;

-- name: ListResourcesForSearch :many
-- The candidate set a slot search generates from.
--
-- Only active resources: SRS-SCH-014 requires an inactive one to be unbookable,
-- and the cheapest way to guarantee that is for its slots never to exist.
SELECT resource_id, tenant_id, facility_id, org_unit_id, resource_type,
       subject_id, display_name, status, time_zone, created_at, updated_at
FROM scheduling.resource
WHERE tenant_id = @tenant_id
  AND status = 'active'
  AND (sqlc.narg('facility_id')::uuid IS NULL OR facility_id = sqlc.narg('facility_id')::uuid)
  AND (sqlc.narg('org_unit_id')::uuid IS NULL OR org_unit_id = sqlc.narg('org_unit_id')::uuid)
  AND (sqlc.narg('resource_id')::uuid IS NULL OR resource_id = sqlc.narg('resource_id')::uuid)
ORDER BY display_name, resource_id
LIMIT @page_limit;

-- name: InsertSchedule :exec
INSERT INTO scheduling.schedule (
    schedule_id, tenant_id, resource_id, facility_id, visit_type, visit_mode,
    weekday, start_minute, end_minute, slot_minutes, capacity,
    effective_from, effective_until, created_at, updated_at
) VALUES (
    @schedule_id, @tenant_id, @resource_id, @facility_id, @visit_type, @visit_mode,
    @weekday, @start_minute, @end_minute, @slot_minutes, @capacity,
    @effective_from, sqlc.narg('effective_until')::date, @created_at, @updated_at
);

-- name: ListSchedulesForResources :many
-- Every rule that could be in force for these resources over a date range.
--
-- Deliberately not filtered by weekday: the generator walks days and asks each
-- rule whether it applies, and a SQL-side weekday filter would have to repeat
-- that reasoning in a second place where it could drift.
SELECT schedule_id, tenant_id, resource_id, facility_id, visit_type, visit_mode,
       weekday, start_minute, end_minute, slot_minutes, capacity,
       effective_from, effective_until, created_at, updated_at
FROM scheduling.schedule
WHERE tenant_id = @tenant_id
  AND resource_id = ANY(@resource_ids::uuid[])
  AND effective_from < @until_date::date
  AND (effective_until IS NULL OR effective_until > @from_date::date)
  AND (@visit_type::text = '' OR visit_type = @visit_type::text)
ORDER BY resource_id, weekday, start_minute;

-- name: DeleteSchedule :execrows
-- Rosters are configuration, not history: a rule withdrawn before it ever took
-- effect should leave nothing behind. A rule that HAS taken effect is ended by
-- setting effective_until instead, which is why this is guarded.
DELETE FROM scheduling.schedule
WHERE tenant_id = @tenant_id
  AND schedule_id = @schedule_id
  AND effective_from > @today::date;

-- name: EndSchedule :execrows
UPDATE scheduling.schedule
SET effective_until = @effective_until, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND schedule_id = @schedule_id;

-- name: InsertException :exec
INSERT INTO scheduling.schedule_exception (
    exception_id, tenant_id, resource_id, kind, starts_at, ends_at,
    reason, overridable, created_by, created_at
) VALUES (
    @exception_id, @tenant_id, @resource_id, @kind, @starts_at, @ends_at,
    @reason, @overridable, @created_by, @created_at
);

-- name: ListExceptionsForResources :many
SELECT exception_id, tenant_id, resource_id, kind, starts_at, ends_at,
       reason, overridable, created_by, created_at
FROM scheduling.schedule_exception
WHERE tenant_id = @tenant_id
  AND resource_id = ANY(@resource_ids::uuid[])
  AND starts_at < @until_at::timestamptz
  AND ends_at > @from_at::timestamptz
ORDER BY resource_id, starts_at;

-- name: DeleteException :execrows
DELETE FROM scheduling.schedule_exception
WHERE tenant_id = @tenant_id AND exception_id = @exception_id;

-- name: CountBookedSlots :many
-- How much capacity is consumed across a window, for the slot search.
--
-- One query for the whole page rather than one per slot: a fortnight of a busy
-- clinic is several hundred slots, and a round trip each would make the search
-- endpoint the slow one.
SELECT resource_id, starts_at, visit_type, capacity, booked
FROM scheduling.slot
WHERE tenant_id = @tenant_id
  AND resource_id = ANY(@resource_ids::uuid[])
  AND starts_at >= @from_at::timestamptz
  AND starts_at < @until_at::timestamptz;

-- name: EnsureSlot :exec
-- Materialises a slot the first time it is booked.
--
-- ON CONFLICT DO NOTHING rather than an upsert: two concurrent first bookings
-- both run this, and the loser must not reset the winner's counter to zero.
-- Capacity is deliberately not refreshed from the roster here either — a
-- roster edited between two bookings must not silently change how many patients
-- the slot already half-full can take.
INSERT INTO scheduling.slot (
    slot_id, tenant_id, resource_id, starts_at, ends_at, visit_type,
    capacity, booked, created_at, updated_at
) VALUES (
    @slot_id, @tenant_id, @resource_id, @starts_at, @ends_at, @visit_type,
    @capacity, 0, @created_at, @updated_at
)
ON CONFLICT (tenant_id, resource_id, starts_at, visit_type) DO NOTHING;

-- name: ClaimSlotCapacity :one
-- Takes one unit of capacity, or reports that there is none (SRS-SCH-004).
--
-- This single statement is the whole of "book atomically and prevent
-- overbooking". UPDATE ... RETURNING takes a row lock, so concurrent claimants
-- serialise and each either gets capacity or does not. Reading the count first
-- and updating second is a race that two bookings both win, and the way it
-- fails — two patients in one slot, under load, not under test — is the way
-- nobody notices until both are in the waiting room.
UPDATE scheduling.slot
SET booked = booked + 1, updated_at = @updated_at
WHERE tenant_id = @tenant_id
  AND resource_id = @resource_id
  AND starts_at = @starts_at
  AND visit_type = @visit_type
  AND booked < capacity
RETURNING slot_id, capacity, booked;

-- name: ReleaseSlotCapacity :execrows
-- Gives capacity back when an appointment is cancelled.
--
-- Guarded on booked > 0 so a double cancellation cannot drive the counter
-- negative and hand the clinic capacity it does not have.
UPDATE scheduling.slot
SET booked = booked - 1, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND slot_id = @slot_id AND booked > 0;

-- name: GetSlot :one
SELECT slot_id, tenant_id, resource_id, starts_at, ends_at, visit_type,
       capacity, booked, created_at, updated_at
FROM scheduling.slot
WHERE tenant_id = @tenant_id AND slot_id = @slot_id;

-- name: InsertAppointment :exec
INSERT INTO scheduling.appointment (
    appointment_id, tenant_id, facility_id, resource_id, org_unit_id,
    patient_id, slot_id, visit_type, visit_mode, starts_at, ends_at,
    status, booked_by, reason, rescheduled_from_id, created_at, updated_at, version,
    series_id, occurrence, reschedule_count, join_url
) VALUES (
    @appointment_id, @tenant_id, @facility_id, @resource_id,
    sqlc.narg('org_unit_id')::uuid, @patient_id, @slot_id, @visit_type, @visit_mode,
    @starts_at, @ends_at, @status, @booked_by, @reason,
    sqlc.narg('rescheduled_from_id')::uuid, @created_at, @updated_at, 1,
    sqlc.narg('series_id')::uuid, sqlc.narg('occurrence')::integer,
    @reschedule_count, @join_url
);

-- name: GetAppointment :one
SELECT appointment_id, tenant_id, facility_id, resource_id, org_unit_id,
       patient_id, slot_id, visit_type, visit_mode, starts_at, ends_at,
       status, booked_by, reason, rescheduled_from_id, created_at, updated_at, version,
       series_id, occurrence, reschedule_count, join_url
FROM scheduling.appointment
WHERE tenant_id = @tenant_id AND appointment_id = @appointment_id;

-- name: SetAppointmentStatus :execrows
-- Optimistic concurrency on version: two clerks checking in the same patient
-- at once would otherwise both write, and the second would overwrite a status
-- it never saw.
UPDATE scheduling.appointment
SET status = @status, updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND appointment_id = @appointment_id
  AND version = @expected_version;

-- name: InsertStatusHistory :exec
INSERT INTO scheduling.appointment_status_history (
    history_id, tenant_id, appointment_id, from_status, to_status,
    changed_at, changed_by, reason, corrected
) VALUES (
    @history_id, @tenant_id, @appointment_id, @from_status, @to_status,
    @changed_at, @changed_by, @reason, @corrected
);

-- name: ListStatusHistory :many
SELECT from_status, to_status, changed_at, changed_by, reason, corrected
FROM scheduling.appointment_status_history
WHERE tenant_id = @tenant_id AND appointment_id = @appointment_id
ORDER BY changed_at, history_id;

-- name: ListAppointmentsForPatient :many
SELECT appointment_id, tenant_id, facility_id, resource_id, org_unit_id,
       patient_id, slot_id, visit_type, visit_mode, starts_at, ends_at,
       status, booked_by, reason, rescheduled_from_id, created_at, updated_at, version,
       series_id, occurrence, reschedule_count, join_url
FROM scheduling.appointment
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY starts_at DESC, appointment_id
LIMIT @page_limit;

-- name: ListAppointmentsForDay :many
-- The clinic list. Cancelled appointments are included: a clerk looking at
-- today needs to see that the 10:15 was cancelled rather than find a gap and
-- wonder whether the diary is wrong.
SELECT appointment_id, tenant_id, facility_id, resource_id, org_unit_id,
       patient_id, slot_id, visit_type, visit_mode, starts_at, ends_at,
       status, booked_by, reason, rescheduled_from_id, created_at, updated_at, version,
       series_id, occurrence, reschedule_count, join_url
FROM scheduling.appointment
WHERE tenant_id = @tenant_id
  AND facility_id = @facility_id
  AND starts_at >= @from_at::timestamptz
  AND starts_at < @until_at::timestamptz
  AND (sqlc.narg('resource_id')::uuid IS NULL OR resource_id = sqlc.narg('resource_id')::uuid)
ORDER BY starts_at, appointment_id
LIMIT @page_limit;

-- name: UpsertCancellationPolicy :exec
INSERT INTO scheduling.cancellation_policy (
    policy_id, tenant_id, facility_id, notice_hours, reschedule_notice_hours,
    max_reschedules, chargeable_when_late, teleconsult_enabled,
    teleconsult_visit_types, teleconsult_requires_confirmed_identity,
    created_at, updated_at
) VALUES (
    @policy_id, @tenant_id, sqlc.narg('facility_id')::uuid, @notice_hours,
    @reschedule_notice_hours, @max_reschedules, @chargeable_when_late,
    @teleconsult_enabled, @teleconsult_visit_types,
    @teleconsult_requires_confirmed_identity, @created_at, @updated_at
)
ON CONFLICT (tenant_id, COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid))
DO UPDATE SET notice_hours = EXCLUDED.notice_hours,
              reschedule_notice_hours = EXCLUDED.reschedule_notice_hours,
              max_reschedules = EXCLUDED.max_reschedules,
              chargeable_when_late = EXCLUDED.chargeable_when_late,
              teleconsult_enabled = EXCLUDED.teleconsult_enabled,
              teleconsult_visit_types = EXCLUDED.teleconsult_visit_types,
              teleconsult_requires_confirmed_identity =
                  EXCLUDED.teleconsult_requires_confirmed_identity,
              updated_at = EXCLUDED.updated_at;

-- name: GetCancellationPolicy :many
-- Facility-specific rows first, so the resolver takes the first it sees.
SELECT notice_hours, reschedule_notice_hours, max_reschedules,
       chargeable_when_late, teleconsult_enabled, teleconsult_visit_types,
       teleconsult_requires_confirmed_identity, facility_id
FROM scheduling.cancellation_policy
WHERE tenant_id = @tenant_id
  AND (facility_id IS NULL OR facility_id = sqlc.narg('facility_id')::uuid)
ORDER BY (facility_id IS NULL);

-- name: InsertPolicyOutcome :exec
INSERT INTO scheduling.appointment_policy_outcome (
    outcome_id, tenant_id, appointment_id, kind, timely,
    notice_given_minutes, notice_required_minutes, chargeable,
    decided_by, decided_at, reason
) VALUES (
    @outcome_id, @tenant_id, @appointment_id, @kind, @timely,
    @notice_given_minutes, @notice_required_minutes, @chargeable,
    @decided_by, @decided_at, @reason
);

-- name: ListPolicyOutcomes :many
SELECT kind, timely, notice_given_minutes, notice_required_minutes,
       chargeable, decided_by, decided_at, reason
FROM scheduling.appointment_policy_outcome
WHERE tenant_id = @tenant_id AND appointment_id = @appointment_id
ORDER BY decided_at, outcome_id;

-- name: InsertSeries :exec
INSERT INTO scheduling.appointment_series (
    series_id, tenant_id, patient_id, resource_id, visit_type,
    interval_days, occurrences, starts_at, created_by, created_at
) VALUES (
    @series_id, @tenant_id, @patient_id, @resource_id, @visit_type,
    @interval_days, @occurrences, @starts_at, @created_by, @created_at
);

-- name: GetSeries :one
SELECT series_id, tenant_id, patient_id, resource_id, visit_type,
       interval_days, occurrences, starts_at, created_by, created_at, cancelled
FROM scheduling.appointment_series
WHERE tenant_id = @tenant_id AND series_id = @series_id;

-- name: ListSeriesAppointments :many
-- Every occurrence of a series, in order, so a bulk change can walk them.
SELECT appointment_id, tenant_id, facility_id, resource_id, org_unit_id,
       patient_id, slot_id, visit_type, visit_mode, starts_at, ends_at,
       status, booked_by, reason, rescheduled_from_id, created_at, updated_at, version,
       series_id, occurrence, reschedule_count, join_url
FROM scheduling.appointment
WHERE tenant_id = @tenant_id AND series_id = @series_id
ORDER BY starts_at, appointment_id;

-- name: CancelSeries :execrows
UPDATE scheduling.appointment_series
SET cancelled = true
WHERE tenant_id = @tenant_id AND series_id = @series_id AND NOT cancelled;

-- name: InsertWaitlistEntry :exec
INSERT INTO scheduling.waitlist_entry (
    waitlist_id, tenant_id, patient_id, resource_id, facility_id, org_unit_id,
    visit_type, not_before, not_after, appointment_id, status,
    created_by, created_at, updated_at
) VALUES (
    @waitlist_id, @tenant_id, @patient_id, sqlc.narg('resource_id')::uuid,
    sqlc.narg('facility_id')::uuid, sqlc.narg('org_unit_id')::uuid,
    @visit_type, sqlc.narg('not_before')::timestamptz,
    sqlc.narg('not_after')::timestamptz, sqlc.narg('appointment_id')::uuid,
    @status, @created_by, @created_at, @updated_at
);

-- name: GetWaitlistEntry :one
SELECT waitlist_id, tenant_id, patient_id, resource_id, facility_id, org_unit_id,
       visit_type, not_before, not_after, appointment_id, status,
       offered_slot_at, offer_expires_at, created_by, created_at, updated_at
FROM scheduling.waitlist_entry
WHERE tenant_id = @tenant_id AND waitlist_id = @waitlist_id;

-- name: ListOpenWaitlistEntries :many
-- The list a scheduler works when a slot frees up. Oldest first: the person who
-- has waited longest is offered first, which is the only ordering anybody can
-- defend at the desk.
SELECT waitlist_id, tenant_id, patient_id, resource_id, facility_id, org_unit_id,
       visit_type, not_before, not_after, appointment_id, status,
       offered_slot_at, offer_expires_at, created_by, created_at, updated_at
FROM scheduling.waitlist_entry
WHERE tenant_id = @tenant_id
  AND status IN ('waiting', 'offered')
  AND (sqlc.narg('resource_id')::uuid IS NULL OR resource_id = sqlc.narg('resource_id')::uuid)
ORDER BY created_at, waitlist_id
LIMIT @page_limit;

-- name: UpdateWaitlistEntry :execrows
-- Guarded on the status the caller read: two schedulers offering the same slot
-- to the same patient would otherwise both write, and the second would replace
-- the first one's offer with an expiry the patient never saw.
UPDATE scheduling.waitlist_entry
SET status = @status,
    offered_slot_at = sqlc.narg('offered_slot_at')::timestamptz,
    offer_expires_at = sqlc.narg('offer_expires_at')::timestamptz,
    updated_at = @updated_at
WHERE tenant_id = @tenant_id
  AND waitlist_id = @waitlist_id
  AND status = @expected_status;

-- name: ExpireStaleOffers :execrows
-- Returns entries whose offer nobody answered to the waiting list.
--
-- Back to waiting rather than to a terminal state: the patient did not answer
-- one message, which is not the same as no longer wanting an appointment.
UPDATE scheduling.waitlist_entry
SET status = 'waiting', offered_slot_at = NULL, offer_expires_at = NULL,
    updated_at = @updated_at
WHERE tenant_id = @tenant_id
  AND status = 'offered'
  AND offer_expires_at <= @now::timestamptz;

-- name: SetAppointmentRescheduled :execrows
-- Records that a booking was moved, carrying the reschedule count forward.
UPDATE scheduling.appointment
SET reschedule_count = @reschedule_count, updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND appointment_id = @appointment_id
  AND version = @expected_version;
