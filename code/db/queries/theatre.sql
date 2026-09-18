-- The operating theatre (SRS-OT).

-- name: UpsertTheatreRoom :exec
INSERT INTO theatre.room (
    room_id, tenant_id, facility_id, code, name, specialties, equipment, active
) VALUES (
    @room_id, @tenant_id, @facility_id, @code, @name, @specialties, @equipment, @active
)
ON CONFLICT (tenant_id, facility_id, code) DO UPDATE
SET name = EXCLUDED.name,
    specialties = EXCLUDED.specialties,
    equipment = EXCLUDED.equipment,
    active = EXCLUDED.active;

-- name: GetTheatreRoom :one
SELECT * FROM theatre.room
WHERE tenant_id = $1 AND room_id = $2;

-- name: ListTheatreRooms :many
SELECT * FROM theatre.room
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
ORDER BY code;

-- name: InsertTheatreBlock :exec
INSERT INTO theatre.block (
    block_id, tenant_id, room_id, kind, owner_id, specialty,
    starts_at, ends_at, note
) VALUES (
    @block_id, @tenant_id, @room_id, @kind, @owner_id, @specialty,
    @starts_at, @ends_at, @note
);

-- name: ListTheatreBlocks :many
SELECT b.* FROM theatre.block b
JOIN theatre.room r ON r.room_id = b.room_id AND r.tenant_id = b.tenant_id
WHERE b.tenant_id = @tenant_id
  AND (@facility_id::text = '' OR r.facility_id = @facility_id)
  AND b.starts_at < @period_end
  AND b.ends_at > @period_start
ORDER BY b.starts_at;

-- name: InsertTheatreCase :exec
INSERT INTO theatre.case (
    case_id, tenant_id, encounter_id, patient_id, facility_id,
    procedure_code, procedure_display, diagnosis_code, diagnosis_display,
    laterality, site, urgency, expected_duration_seconds,
    surgeon_id, team, requirements, anaesthesia_type, special_notes,
    status, requested_by, requested_at, updated_at, version
) VALUES (
    @case_id, @tenant_id, @encounter_id, @patient_id, @facility_id,
    @procedure_code, @procedure_display, @diagnosis_code, @diagnosis_display,
    @laterality, @site, @urgency, @expected_duration_seconds,
    @surgeon_id, @team, @requirements, @anaesthesia_type, @special_notes,
    @status, @requested_by, @requested_at, @updated_at, 1
);

-- name: GetTheatreCase :one
SELECT * FROM theatre.case
WHERE tenant_id = $1 AND case_id = $2;

-- name: UpdateTheatreCase :execrows
-- Guarded on the version, so two schedulers booking the same slot do not both
-- win.
UPDATE theatre.case
SET diagnosis_code = @diagnosis_code,
    diagnosis_display = @diagnosis_display,
    laterality = @laterality,
    site = @site,
    urgency = @urgency,
    expected_duration_seconds = @expected_duration_seconds,
    surgeon_id = @surgeon_id,
    team = @team,
    requirements = @requirements,
    anaesthesia_type = @anaesthesia_type,
    special_notes = @special_notes,
    status = @status,
    room_id = sqlc.narg('room_id')::uuid,
    scheduled_start = sqlc.narg('scheduled_start')::timestamptz,
    scheduled_end = sqlc.narg('scheduled_end')::timestamptz,
    outcome = @outcome,
    outcome_reason = @outcome_reason,
    outcome_note = @outcome_note,
    outcome_at = sqlc.narg('outcome_at')::timestamptz,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND case_id = @case_id
  AND version = @expected_version;

-- name: ListTheatreCasesForRoom :many
-- The day's list in one room, which is what the board and the slot check read.
SELECT * FROM theatre.case
WHERE tenant_id = @tenant_id
  AND room_id = @room_id
  AND scheduled_start < @period_end
  AND scheduled_end > @period_start
ORDER BY scheduled_start;

-- name: ListTheatreCasesInPeriod :many
-- Every case in a period, room or not, for utilisation and cancellation
-- analytics.
SELECT * FROM theatre.case
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (
      (scheduled_start IS NOT NULL AND scheduled_start < @period_end
       AND scheduled_start >= @period_start)
      OR (scheduled_start IS NULL AND outcome_at IS NOT NULL
          AND outcome_at < @period_end AND outcome_at >= @period_start)
  )
ORDER BY scheduled_start NULLS LAST, requested_at;

-- name: ListSurgeonTheatreCases :many
-- A surgeon's own diary, for the "operating elsewhere" check.
SELECT * FROM theatre.case
WHERE tenant_id = @tenant_id
  AND surgeon_id = @surgeon_id
  AND status NOT IN ('completed', 'cancelled')
  AND scheduled_start < @period_end
  AND scheduled_end > @period_start
ORDER BY scheduled_start;

-- name: ListWaitingTheatreCases :many
SELECT * FROM theatre.case
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND status IN ('requested', 'schedulable', 'postponed')
ORDER BY requested_at
LIMIT @row_limit;

-- name: UpsertPreopEntry :exec
INSERT INTO theatre.preop_entry (
    case_id, tenant_id, code, state, note, waived_by, waived_role,
    recorded_by, recorded_at
) VALUES (
    @case_id, @tenant_id, @code, @state, @note, @waived_by, @waived_role,
    @recorded_by, @recorded_at
)
ON CONFLICT (case_id, code) DO UPDATE
SET state = EXCLUDED.state,
    note = EXCLUDED.note,
    waived_by = EXCLUDED.waived_by,
    waived_role = EXCLUDED.waived_role,
    recorded_by = EXCLUDED.recorded_by,
    recorded_at = EXCLUDED.recorded_at;

-- name: ListPreopEntries :many
SELECT * FROM theatre.preop_entry
WHERE tenant_id = $1 AND case_id = $2
ORDER BY code;

-- name: InsertSafetyCheck :exec
INSERT INTO theatre.safety_check (
    check_id, tenant_id, case_id, phase, participants, performed_at, performed_by
) VALUES (
    @check_id, @tenant_id, @case_id, @phase, @participants, @performed_at, @performed_by
);

-- name: InsertSafetyAnswer :exec
INSERT INTO theatre.safety_answer (check_id, code, confirmed, exception)
VALUES (@check_id, @code, @confirmed, @exception);

-- name: ListSafetyChecks :many
SELECT * FROM theatre.safety_check
WHERE tenant_id = $1 AND case_id = $2
ORDER BY performed_at;

-- name: ListSafetyAnswers :many
SELECT * FROM theatre.safety_answer
WHERE check_id = $1
ORDER BY code;

-- name: InsertTheatreMilestone :exec
INSERT INTO theatre.milestone (
    milestone_id, tenant_id, case_id, milestone,
    occurred_at, recorded_at, recorded_by, note
) VALUES (
    @milestone_id, @tenant_id, @case_id, @milestone,
    @occurred_at, @recorded_at, @recorded_by, @note
);

-- name: ListTheatreMilestones :many
SELECT * FROM theatre.milestone
WHERE tenant_id = $1 AND case_id = $2
ORDER BY occurred_at;

-- name: ListTheatreMilestonesForCases :many
-- Every milestone for a set of cases, so the board and the utilisation report
-- read them in one round trip rather than one per case.
SELECT * FROM theatre.milestone
WHERE tenant_id = @tenant_id
  AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, occurred_at;

-- name: InsertTheatreDelay :exec
INSERT INTO theatre.delay (
    delay_id, tenant_id, case_id, reason, dependency, minutes, note,
    recorded_at, recorded_by
) VALUES (
    @delay_id, @tenant_id, @case_id, @reason, @dependency, @minutes, @note,
    @recorded_at, @recorded_by
);

-- name: ListTheatreDelaysForCases :many
SELECT * FROM theatre.delay
WHERE tenant_id = @tenant_id
  AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, recorded_at;

-- name: InsertOperativeNote :exec
INSERT INTO theatre.operative_note (
    note_id, tenant_id, case_id, version, supersedes,
    procedure_performed, findings, specimen_ids, implant_ids, complications,
    estimated_blood_loss_ml, post_operative_orders, narrative,
    status, amendment_reason, authored_by, authored_at, signed_by, signed_at
) VALUES (
    @note_id, @tenant_id, @case_id, @version, sqlc.narg('supersedes')::uuid,
    @procedure_performed, @findings, @specimen_ids, @implant_ids, @complications,
    @estimated_blood_loss_ml, @post_operative_orders, @narrative,
    @status, @amendment_reason, @authored_by, @authored_at, @signed_by,
    sqlc.narg('signed_at')::timestamptz
);

-- name: SignOperativeNote :execrows
UPDATE theatre.operative_note
SET status = 'signed', signed_by = @signed_by, signed_at = @signed_at
WHERE tenant_id = @tenant_id
  AND note_id = @note_id
  AND status = 'draft';

-- name: SupersedeOperativeNote :execrows
UPDATE theatre.operative_note
SET status = 'superseded'
WHERE tenant_id = @tenant_id
  AND note_id = @note_id
  AND status <> 'superseded';

-- name: ListOperativeNotes :many
SELECT * FROM theatre.operative_note
WHERE tenant_id = $1 AND case_id = $2
ORDER BY version;

-- name: InsertTheatreUsage :exec
INSERT INTO theatre.usage (
    usage_id, tenant_id, case_id, kind, item_code, item_name,
    lot_number, serial_number, quantity, expiry_date,
    scanned, scan_data, recorded_at, recorded_by
) VALUES (
    @usage_id, @tenant_id, @case_id, @kind, @item_code, @item_name,
    @lot_number, @serial_number, @quantity, sqlc.narg('expiry_date')::timestamptz,
    @scanned, @scan_data, @recorded_at, @recorded_by
);

-- name: ListTheatreUsage :many
SELECT * FROM theatre.usage
WHERE tenant_id = $1 AND case_id = $2
ORDER BY recorded_at;

-- name: FindImplantUsage :many
-- The implant register, which is what a recall is worked from: every patient
-- who received a given item, optionally narrowed to a lot.
SELECT u.*, c.patient_id, c.encounter_id
FROM theatre.usage u
JOIN theatre.case c ON c.case_id = u.case_id AND c.tenant_id = u.tenant_id
WHERE u.tenant_id = @tenant_id
  AND u.kind = 'implant'
  AND u.item_code = @item_code
  AND (@lot_number::text = '' OR u.lot_number = @lot_number)
ORDER BY u.recorded_at;

-- name: InsertTheatreSpecimen :exec
INSERT INTO theatre.specimen (
    specimen_id, tenant_id, case_id, patient_id, label, site, laterality,
    container, fixative, taken_at, taken_by
) VALUES (
    @specimen_id, @tenant_id, @case_id, @patient_id, @label, @site, @laterality,
    @container, @fixative, @taken_at, @taken_by
);

-- name: AccessionTheatreSpecimen :execrows
-- Refuses one already accessioned, so two orders cannot both claim the same
-- pot.
UPDATE theatre.specimen
SET order_id = @order_id
WHERE tenant_id = @tenant_id
  AND specimen_id = @specimen_id
  AND order_id IS NULL;

-- name: ListTheatreSpecimens :many
SELECT * FROM theatre.specimen
WHERE tenant_id = $1 AND case_id = $2
ORDER BY taken_at;

-- name: ListUnaccessionedSpecimens :many
SELECT s.* FROM theatre.specimen s
JOIN theatre.case c ON c.case_id = s.case_id AND c.tenant_id = s.tenant_id
WHERE s.tenant_id = @tenant_id
  AND (@facility_id::text = '' OR c.facility_id = @facility_id)
  AND s.order_id IS NULL
ORDER BY s.taken_at
LIMIT @row_limit;

-- name: InsertTrayUse :exec
INSERT INTO theatre.tray_use (
    tray_use_id, tenant_id, case_id, tray_id, tray_name, cycle_id,
    indicator_passed, indicator_note, opened_at, opened_by
) VALUES (
    @tray_use_id, @tenant_id, @case_id, @tray_id, @tray_name, @cycle_id,
    @indicator_passed, @indicator_note, @opened_at, @opened_by
);

-- name: ListTrayUses :many
SELECT * FROM theatre.tray_use
WHERE tenant_id = $1 AND case_id = $2
ORDER BY opened_at;

-- name: ListTrayUsesForCycle :many
-- The direction an infection investigation runs: from a sterilisation cycle to
-- the patients whose cases used it.
SELECT t.*, c.patient_id, c.encounter_id
FROM theatre.tray_use t
JOIN theatre.case c ON c.case_id = t.case_id AND c.tenant_id = t.tenant_id
WHERE t.tenant_id = @tenant_id AND t.cycle_id = @cycle_id
ORDER BY t.opened_at;

-- name: UpsertPreferenceCard :exec
INSERT INTO theatre.preference_card (
    card_id, tenant_id, surgeon_id, procedure_code, name,
    equipment, consumables, trays, notes, version, updated_at, updated_by
) VALUES (
    @card_id, @tenant_id, @surgeon_id, @procedure_code, @name,
    @equipment, @consumables, @trays, @notes, 1, @updated_at, @updated_by
)
ON CONFLICT (tenant_id, surgeon_id, procedure_code) DO UPDATE
SET name = EXCLUDED.name,
    equipment = EXCLUDED.equipment,
    consumables = EXCLUDED.consumables,
    trays = EXCLUDED.trays,
    notes = EXCLUDED.notes,
    version = theatre.preference_card.version + 1,
    updated_at = EXCLUDED.updated_at,
    updated_by = EXCLUDED.updated_by;

-- name: GetPreferenceCard :one
SELECT * FROM theatre.preference_card
WHERE tenant_id = $1 AND surgeon_id = $2 AND procedure_code = $3;
