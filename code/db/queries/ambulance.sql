-- Ambulance and fleet operations (SRS-AMB-001 … 008).
--
-- Every statement is tenant-scoped in its WHERE clause. The adapter cannot be
-- called without authctx.TenantScope and the scope's tenant is what lands in
-- @tenant_id, so a cross-tenant read is not a thing a caller can ask for
-- (ADR-0001, FIT-03).
--
-- There is no UPDATE and no DELETE against ambulance.trip_milestone. A
-- timeline somebody can rewrite is one nobody can audit, and a correction is
-- an insert carrying amends_at rather than an edit (FIT-08).
--
-- There is no statement that reads a location ping past its retain_until.
-- The horizon is enforced on the read as well as by the purge, so a feed does
-- not come back because the purge job is behind.

-- name: InsertVehicle :exec
INSERT INTO ambulance.vehicle (
    vehicle_id, tenant_id, registration, call_sign, kind, facility_id,
    base_id, capabilities, state, ready_until, out_of_service_reason,
    created_at, created_by, version
) VALUES (
    @vehicle_id, @tenant_id, @registration, @call_sign, @kind, @facility_id,
    @base_id, @capabilities, @state, @ready_until, @out_of_service_reason,
    @created_at, @created_by, @version
);

-- name: GetVehicle :one
SELECT * FROM ambulance.vehicle
WHERE tenant_id = @tenant_id AND vehicle_id = @vehicle_id;

-- name: UpdateVehicleState :execrows
UPDATE ambulance.vehicle
SET state = @state, ready_until = @ready_until,
    out_of_service_reason = @out_of_service_reason, version = version + 1
WHERE tenant_id = @tenant_id AND vehicle_id = @vehicle_id
  AND version = @expected_version;

-- name: ListVehicles :many
SELECT * FROM ambulance.vehicle
WHERE tenant_id = @tenant_id
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (cardinality(@kinds::text[]) = 0 OR kind = ANY(@kinds::text[]))
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
ORDER BY call_sign, registration
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertAmbulanceShift :exec
INSERT INTO ambulance.shift (
    shift_id, tenant_id, vehicle_id, facility_id, state, starts_at, ends_at,
    started_at, ended_at, created_at, created_by, version
) VALUES (
    @shift_id, @tenant_id, @vehicle_id, @facility_id, @state, @starts_at,
    @ends_at, @started_at, @ended_at, @created_at, @created_by, @version
);

-- name: InsertAmbulanceShiftCrew :exec
INSERT INTO ambulance.shift_crew (
    shift_id, subject_id, display_name, role, registration_number
) VALUES (
    @shift_id, @subject_id, @display_name, @role, @registration_number
);

-- name: GetAmbulanceShift :one
SELECT * FROM ambulance.shift
WHERE tenant_id = @tenant_id AND shift_id = @shift_id;

-- name: ListAmbulanceShiftCrew :many
SELECT * FROM ambulance.shift_crew
WHERE shift_id = ANY(@shift_ids::uuid[])
ORDER BY shift_id, role, subject_id;

-- name: UpdateAmbulanceShiftState :execrows
UPDATE ambulance.shift
SET state = @state, started_at = @started_at, ended_at = @ended_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND shift_id = @shift_id
  AND version = @expected_version;

-- name: ListAmbulanceShifts :many
SELECT * FROM ambulance.shift
WHERE tenant_id = @tenant_id
  AND (@vehicle_id::text = '' OR vehicle_id = @vehicle_id::uuid)
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND starts_at < @window_to AND ends_at > @window_from
ORDER BY starts_at DESC
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertReadinessCheck :exec
INSERT INTO ambulance.readiness_check (
    check_id, tenant_id, vehicle_id, shift_id, facility_id, oxygen_bar,
    oxygen_minimum_bar, state, missing, override_by, override_reason,
    override_at, checked_by, valid_until, checked_at, version
) VALUES (
    @check_id, @tenant_id, @vehicle_id, @shift_id, @facility_id, @oxygen_bar,
    @oxygen_minimum_bar, @state, @missing, @override_by, @override_reason,
    @override_at, @checked_by, @valid_until, @checked_at, @version
);

-- name: InsertReadinessOutcome :exec
INSERT INTO ambulance.readiness_outcome (
    check_id, item_code, label, critical, present, note
) VALUES (
    @check_id, @item_code, @label, @critical, @present, @note
);

-- name: GetReadinessCheck :one
SELECT * FROM ambulance.readiness_check
WHERE tenant_id = @tenant_id AND check_id = @check_id;

-- name: ListReadinessOutcomes :many
SELECT * FROM ambulance.readiness_outcome
WHERE check_id = ANY(@check_ids::uuid[])
ORDER BY check_id, item_code;

-- name: UpdateReadinessOverride :execrows
UPDATE ambulance.readiness_check
SET state = @state, override_by = @override_by,
    override_reason = @override_reason, override_at = @override_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND check_id = @check_id
  AND version = @expected_version;

-- name: ListReadinessChecks :many
SELECT * FROM ambulance.readiness_check
WHERE tenant_id = @tenant_id
  AND (@vehicle_id::text = '' OR vehicle_id = @vehicle_id::uuid)
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND checked_at >= @window_from AND checked_at < @window_to
ORDER BY checked_at DESC
LIMIT @row_limit OFFSET @row_offset;

-- name: LatestReadinessCheck :one
SELECT * FROM ambulance.readiness_check
WHERE tenant_id = @tenant_id AND vehicle_id = @vehicle_id
ORDER BY checked_at DESC
LIMIT 1;

-- name: InsertAmbulanceRequest :exec
INSERT INTO ambulance.request (
    request_id, tenant_id, kind, priority, patient_id, encounter_id,
    origin_name, origin_address, origin_facility_id, destination_name,
    destination_address, destination_facility_id, clinical_need,
    required_capabilities, state, trip_id, cancel_reason, cancelled_by,
    cancelled_at, requested_at, requested_by, version
) VALUES (
    @request_id, @tenant_id, @kind, @priority, @patient_id, @encounter_id,
    @origin_name, @origin_address, @origin_facility_id, @destination_name,
    @destination_address, @destination_facility_id, @clinical_need,
    @required_capabilities, @state, @trip_id, @cancel_reason, @cancelled_by,
    @cancelled_at, @requested_at, @requested_by, @version
);

-- name: GetAmbulanceRequest :one
SELECT * FROM ambulance.request
WHERE tenant_id = @tenant_id AND request_id = @request_id;

-- name: UpdateAmbulanceRequestState :execrows
UPDATE ambulance.request
SET state = @state, trip_id = @trip_id, cancel_reason = @cancel_reason,
    cancelled_by = @cancelled_by, cancelled_at = @cancelled_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND request_id = @request_id
  AND version = @expected_version;

-- name: ListAmbulanceRequests :many
SELECT * FROM ambulance.request
WHERE tenant_id = @tenant_id
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (cardinality(@priorities::text[]) = 0
       OR priority = ANY(@priorities::text[]))
  AND (cardinality(@kinds::text[]) = 0 OR kind = ANY(@kinds::text[]))
  AND (@facility_id::text = ''
       OR origin_facility_id = @facility_id::uuid
       OR destination_facility_id = @facility_id::uuid)
  AND (@patient_id::text = '' OR patient_id = @patient_id::uuid)
  AND requested_at >= @window_from AND requested_at < @window_to
ORDER BY requested_at DESC
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertTrip :exec
INSERT INTO ambulance.trip (
    trip_id, tenant_id, request_id, vehicle_id, shift_id, facility_id,
    priority, vehicle_kind, shift_vehicle_id, crew_subjects, override_by,
    override_reason, state, abort_reason, started_at, started_by, ended_at,
    version
) VALUES (
    @trip_id, @tenant_id, @request_id, @vehicle_id, @shift_id, @facility_id,
    @priority, @vehicle_kind, @shift_vehicle_id, @crew_subjects,
    @override_by, @override_reason, @state, @abort_reason, @started_at,
    @started_by, @ended_at, @version
);

-- name: GetTrip :one
SELECT * FROM ambulance.trip
WHERE tenant_id = @tenant_id AND trip_id = @trip_id;

-- name: GetTripForRequest :one
-- The latest attempt. A call answered twice has two trips, and the one a
-- caller means is the one still running or the one that ran last.
SELECT * FROM ambulance.trip
WHERE tenant_id = @tenant_id AND request_id = @request_id
ORDER BY started_at DESC
LIMIT 1;

-- name: UpdateTripState :execrows
UPDATE ambulance.trip
SET state = @state, abort_reason = @abort_reason, ended_at = @ended_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND trip_id = @trip_id
  AND version = @expected_version;

-- name: ListTrips :many
SELECT * FROM ambulance.trip
WHERE tenant_id = @tenant_id
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (@vehicle_id::text = '' OR vehicle_id = @vehicle_id::uuid)
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND started_at >= @window_from AND started_at < @window_to
ORDER BY started_at DESC
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertTripMilestone :exec
INSERT INTO ambulance.trip_milestone (
    milestone_id, tenant_id, trip_id, milestone, occurred_at, recorded_by,
    note, amends_at, amend_reason, amended_at
) VALUES (
    @milestone_id, @tenant_id, @trip_id, @milestone, @occurred_at,
    @recorded_by, @note, @amends_at, @amend_reason, @amended_at
);

-- name: ListTripMilestones :many
SELECT * FROM ambulance.trip_milestone
WHERE tenant_id = @tenant_id AND trip_id = ANY(@trip_ids::uuid[])
-- By insertion order, not by the time each point claims. A correction
-- carries an earlier time than the record it supersedes, and reading them
-- back by occurred_at would put the correction first and the superseded
-- value last.
ORDER BY trip_id, seq;

-- name: InsertPrehospitalRecord :exec
INSERT INTO ambulance.prehospital_record (
    record_id, tenant_id, trip_id, request_id, patient_id, encounter_id,
    facility_id, presenting_complaint, impression, state, sending_summary,
    given_by, given_role, given_at, accepted_by, accepted_at, accepted_note,
    created_at, created_by, version
) VALUES (
    @record_id, @tenant_id, @trip_id, @request_id, @patient_id,
    @encounter_id, @facility_id, @presenting_complaint, @impression, @state,
    @sending_summary, @given_by, @given_role, @given_at, @accepted_by,
    @accepted_at, @accepted_note, @created_at, @created_by, @version
);

-- name: GetPrehospitalRecord :one
SELECT * FROM ambulance.prehospital_record
WHERE tenant_id = @tenant_id AND record_id = @record_id;

-- name: GetPrehospitalRecordForTrip :one
SELECT * FROM ambulance.prehospital_record
WHERE tenant_id = @tenant_id AND trip_id = @trip_id;

-- name: UpdatePrehospitalRecord :execrows
UPDATE ambulance.prehospital_record
SET impression = @impression, state = @state,
    sending_summary = @sending_summary, given_by = @given_by,
    given_role = @given_role, given_at = @given_at,
    accepted_by = @accepted_by, accepted_at = @accepted_at,
    accepted_note = @accepted_note, encounter_id = @encounter_id,
    version = version + 1
WHERE tenant_id = @tenant_id AND record_id = @record_id
  AND version = @expected_version;

-- name: ListPrehospitalRecords :many
SELECT * FROM ambulance.prehospital_record
WHERE tenant_id = @tenant_id
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@patient_id::text = '' OR patient_id = @patient_id::uuid)
  AND created_at >= @window_from AND created_at < @window_to
ORDER BY created_at DESC
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertPrehospitalEntry :exec
INSERT INTO ambulance.prehospital_entry (
    entry_id, tenant_id, record_id, kind, code, label, value, unit,
    dose_amount, dose_unit, route, narrative, recorded_by, recorded_role,
    recorded_at, entered_at
) VALUES (
    @entry_id, @tenant_id, @record_id, @kind, @code, @label, @value, @unit,
    @dose_amount, @dose_unit, @route, @narrative, @recorded_by,
    @recorded_role, @recorded_at, @entered_at
);

-- name: ListPrehospitalEntries :many
SELECT * FROM ambulance.prehospital_entry
WHERE tenant_id = @tenant_id AND record_id = ANY(@record_ids::uuid[])
ORDER BY record_id, recorded_at, entry_id;

-- name: InsertPrehospitalDocument :exec
INSERT INTO ambulance.prehospital_document (record_id, document_ref,
    attached_at)
VALUES (@record_id, @document_ref, @attached_at);

-- name: ListPrehospitalDocuments :many
SELECT * FROM ambulance.prehospital_document
WHERE record_id = ANY(@record_ids::uuid[])
ORDER BY record_id, attached_at;

-- name: InsertLocationPing :exec
INSERT INTO ambulance.location_ping (
    ping_id, tenant_id, vehicle_id, trip_id, latitude_micro,
    longitude_micro, speed_kph, heading_degrees, accuracy_metres, source,
    occurred_at, retain_until
) VALUES (
    @ping_id, @tenant_id, @vehicle_id, @trip_id, @latitude_micro,
    @longitude_micro, @speed_kph, @heading_degrees, @accuracy_metres,
    @source, @occurred_at, @retain_until
);

-- name: ListLocationPings :many
SELECT * FROM ambulance.location_ping
WHERE tenant_id = @tenant_id
  AND (@vehicle_id::text = '' OR vehicle_id = @vehicle_id::uuid)
  AND (@trip_id::text = '' OR trip_id = @trip_id::uuid)
  AND occurred_at >= @window_from AND occurred_at < @window_to
  -- The horizon is enforced here as well as by the purge: a trail does not
  -- come back because the purge job is behind.
  AND retain_until > @as_of
ORDER BY occurred_at DESC
LIMIT @row_limit;

-- name: LatestLocationPing :one
SELECT * FROM ambulance.location_ping
WHERE tenant_id = @tenant_id AND vehicle_id = @vehicle_id
  AND retain_until > @as_of
ORDER BY occurred_at DESC
LIMIT 1;

-- name: PurgeExpiredLocationPings :execrows
DELETE FROM ambulance.location_ping
WHERE tenant_id = @tenant_id AND retain_until <= @as_of;

-- name: InsertETA :exec
INSERT INTO ambulance.eta (
    eta_id, tenant_id, vehicle_id, trip_id, seconds, distance_metres,
    source, occurred_at
) VALUES (
    @eta_id, @tenant_id, @vehicle_id, @trip_id, @seconds, @distance_metres,
    @source, @occurred_at
);

-- name: LatestETA :one
SELECT * FROM ambulance.eta
WHERE tenant_id = @tenant_id AND trip_id = @trip_id
ORDER BY occurred_at DESC
LIMIT 1;
