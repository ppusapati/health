-- Sterile services / CSSD (SRS-CSSD-001 … 012).

-- name: InsertInstrument :exec
INSERT INTO sterile.instrument (
    instrument_id, tenant_id, code, display, serial_number, status, location,
    acquired_on, notes, created_at, created_by
) VALUES (
    @instrument_id, @tenant_id, @code, @display, @serial_number, @status,
    @location, @acquired_on, @notes, @created_at, @created_by
);

-- name: GetInstrument :one
SELECT * FROM sterile.instrument
WHERE tenant_id = $1 AND instrument_id = $2;

-- name: UpdateInstrumentStatus :execrows
UPDATE sterile.instrument
SET status = @status, location = @location, notes = @notes,
    retired_on = @retired_on, version = version + 1
WHERE tenant_id = @tenant_id AND instrument_id = @instrument_id
  AND version = @expected_version;

-- name: ListInstruments :many
SELECT * FROM sterile.instrument
WHERE tenant_id = @tenant_id
  AND (@code::text = '' OR code = @code)
ORDER BY code, serial_number
LIMIT @row_limit;

-- The lifecycle history one move at a time (SRS-CSSD-012). Append-only: no
-- update or delete exists for this table.
-- name: InsertInstrumentEvent :exec
INSERT INTO sterile.instrument_event (
    instrument_event_id, tenant_id, instrument_id, from_status, to_status,
    note, location, occurred_at, recorded_by
) VALUES (
    @instrument_event_id, @tenant_id, @instrument_id, @from_status,
    @to_status, @note, @location, @occurred_at, @recorded_by
);

-- One instrument's history, most recent first. The replacement question:
-- how many times has this item been away this year.
-- name: ListInstrumentEvents :many
SELECT * FROM sterile.instrument_event
WHERE tenant_id = @tenant_id AND instrument_id = @instrument_id
ORDER BY occurred_at DESC
LIMIT @row_limit;

-- Every move of one kind across the master. The loss analysis: which codes
-- keep going missing, and where they were last seen.
-- name: ListInstrumentEventsByStatus :many
SELECT e.* FROM sterile.instrument_event e
WHERE e.tenant_id = @tenant_id AND e.to_status = @to_status
  AND e.occurred_at >= @period_start AND e.occurred_at < @period_end
ORDER BY e.occurred_at DESC
LIMIT @row_limit;

-- The lifecycle worklist: what is away, missing or retired (SRS-CSSD-012).
-- name: ListInstrumentsOutOfService :many
SELECT * FROM sterile.instrument
WHERE tenant_id = @tenant_id AND status <> 'in_service'
ORDER BY status, code
LIMIT @row_limit;

-- name: InsertTraySet :exec
INSERT INTO sterile.tray_set (
    set_id, tenant_id, code, display, kind, set_version, supersedes,
    items, shelf_life_seconds, created_at, created_by
) VALUES (
    @set_id, @tenant_id, @code, @display, @kind, @set_version, @supersedes,
    @items, @shelf_life_seconds, @created_at, @created_by
);

-- Supersession is a separate statement because the one-current index forbids
-- two live versions of a code: the old row has to be closed before the new one
-- may exist.
-- name: SupersedeTraySet :execrows
UPDATE sterile.tray_set
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND set_id = @set_id
  AND superseded_at IS NULL;

-- name: GetTraySet :one
SELECT * FROM sterile.tray_set
WHERE tenant_id = $1 AND set_id = $2;

-- name: GetCurrentTraySet :one
SELECT * FROM sterile.tray_set
WHERE tenant_id = @tenant_id AND code = @code AND superseded_at IS NULL;

-- name: ListTraySetVersions :many
SELECT * FROM sterile.tray_set
WHERE tenant_id = @tenant_id AND code = @code
ORDER BY set_version;

-- name: ListTraySets :many
SELECT * FROM sterile.tray_set
WHERE tenant_id = @tenant_id AND superseded_at IS NULL
ORDER BY code
LIMIT @row_limit;

-- name: InsertCycle :exec
INSERT INTO sterile.cycle (
    cycle_id, tenant_id, machine, load_number, program, parameters, source,
    result, started_at, started_by
) VALUES (
    @cycle_id, @tenant_id, @machine, @load_number, @program, @parameters,
    @source, @result, @started_at, @started_by
);

-- name: GetCycle :one
SELECT * FROM sterile.cycle WHERE tenant_id = $1 AND cycle_id = $2;

-- name: GetCycleByLoad :one
SELECT * FROM sterile.cycle
WHERE tenant_id = @tenant_id AND machine = @machine
  AND load_number = @load_number;

-- name: UpdateCycle :execrows
UPDATE sterile.cycle
SET result = @result, parameters = @parameters, ended_at = @ended_at,
    released = @released, released_by = @released_by,
    released_at = @released_at, release_note = @release_note,
    version = version + 1
WHERE tenant_id = @tenant_id AND cycle_id = @cycle_id
  AND version = @expected_version;

-- The loads that have finished and not been cleared (SRS-CSSD-007).
-- name: ListCyclesAwaitingRelease :many
SELECT * FROM sterile.cycle
WHERE tenant_id = @tenant_id AND NOT released AND result = 'passed'
ORDER BY ended_at
LIMIT @row_limit;

-- name: ListCyclesForMachine :many
SELECT * FROM sterile.cycle
WHERE tenant_id = @tenant_id AND machine = @machine
  AND started_at >= @period_start AND started_at < @period_end
ORDER BY started_at DESC
LIMIT @row_limit;

-- name: InsertIndicator :exec
INSERT INTO sterile.indicator (
    indicator_id, tenant_id, cycle_id, kind, lot, passed, notes,
    read_at, read_by
) VALUES (
    @indicator_id, @tenant_id, @cycle_id, @kind, @lot, @passed, @notes,
    @read_at, @read_by
);

-- name: ListIndicators :many
SELECT * FROM sterile.indicator
WHERE tenant_id = @tenant_id AND cycle_id = @cycle_id
ORDER BY read_at;

-- The direction a bad-batch investigation runs: from an indicator lot to every
-- load it cleared.
-- name: ListCyclesClearedByLot :many
SELECT DISTINCT c.* FROM sterile.cycle c
JOIN sterile.indicator i
  ON i.cycle_id = c.cycle_id AND i.tenant_id = c.tenant_id
WHERE c.tenant_id = @tenant_id AND i.lot = @lot AND i.passed
ORDER BY c.started_at DESC
LIMIT @row_limit;

-- name: InsertRun :exec
INSERT INTO sterile.run (
    run_id, tenant_id, set_id, set_version, set_code, source_unit,
    source_case_id, stage, received_count, packed_count, missing, replaced,
    started_at, started_by
) VALUES (
    @run_id, @tenant_id, @set_id, @set_version, @set_code, @source_unit,
    @source_case_id, @stage, @received_count, @packed_count, @missing,
    @replaced, @started_at, @started_by
);

-- name: GetRun :one
SELECT * FROM sterile.run WHERE tenant_id = $1 AND run_id = $2;

-- name: UpdateRun :execrows
UPDATE sterile.run
SET stage = @stage, packed_count = @packed_count, missing = @missing,
    replaced = @replaced, cycle_id = @cycle_id,
    packaging_method = @packaging_method, indicator_type = @indicator_type,
    sterilised_at = @sterilised_at, expires_at = @expires_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND run_id = @run_id
  AND version = @expected_version;

-- name: ListRunsForCycle :many
SELECT * FROM sterile.run
WHERE tenant_id = @tenant_id AND cycle_id = @cycle_id
ORDER BY set_code;

-- The department's own board: what is in progress and how far along.
-- name: ListRunsInProgress :many
SELECT * FROM sterile.run
WHERE tenant_id = @tenant_id AND stage <> 'released'
ORDER BY started_at
LIMIT @row_limit;

-- The shelf: released packs, soonest to expire first, so the department issues
-- the pack that would otherwise be wasted.
-- name: ListShelf :many
SELECT * FROM sterile.run
WHERE tenant_id = @tenant_id
  AND stage = 'released'
  AND expires_at > @as_of
  AND (@set_code::text = '' OR set_code = @set_code)
ORDER BY expires_at
LIMIT @row_limit;

-- Packs past their sterile life, for the sweep that takes them off the shelf.
-- name: ListExpiredPacks :many
SELECT * FROM sterile.run
WHERE tenant_id = @tenant_id AND stage = 'released' AND expires_at <= @as_of
ORDER BY expires_at
LIMIT @row_limit;

-- name: InsertStageRecord :exec
INSERT INTO sterile.stage_record (
    stage_record_id, tenant_id, run_id, stage, equipment, notes,
    skipped, skip_authorised_by, skip_reason, performed_at, performed_by
) VALUES (
    @stage_record_id, @tenant_id, @run_id, @stage, @equipment, @notes,
    @skipped, @skip_authorised_by, @skip_reason, @performed_at, @performed_by
);

-- name: ListStageRecords :many
SELECT * FROM sterile.stage_record
WHERE tenant_id = @tenant_id AND run_id = @run_id
ORDER BY performed_at;

-- The exceptions register, which is what a quality review reads.
-- name: ListSkippedStages :many
SELECT * FROM sterile.stage_record
WHERE tenant_id = @tenant_id AND skipped
  AND performed_at >= @period_start AND performed_at < @period_end
ORDER BY performed_at DESC
LIMIT @row_limit;

-- name: InsertSterileIssue :exec
INSERT INTO sterile.issue (
    issue_id, tenant_id, run_id, set_code, cycle_id, destination, issued_to,
    state, issued_at, issued_by
) VALUES (
    @issue_id, @tenant_id, @run_id, @set_code, @cycle_id, @destination,
    @issued_to, @state, @issued_at, @issued_by
);

-- name: GetSterileIssue :one
SELECT * FROM sterile.issue WHERE tenant_id = $1 AND issue_id = $2;

-- name: UpdateSterileIssue :execrows
UPDATE sterile.issue
SET state = @state, used_case_id = @used_case_id,
    return_count = @return_count, return_note = @return_note,
    closed_at = @closed_at, closed_by = @closed_by
WHERE tenant_id = @tenant_id AND issue_id = @issue_id;

-- name: ListIssuesForRun :many
SELECT * FROM sterile.issue
WHERE tenant_id = @tenant_id AND run_id = @run_id
ORDER BY issued_at;

-- SRS-CSSD-010: from a patient's operation back to every set it used.
-- name: ListIssuesForCase :many
SELECT * FROM sterile.issue
WHERE tenant_id = @tenant_id AND used_case_id = @used_case_id
ORDER BY issued_at;

-- What is out, so a recall knows where to go.
-- name: ListOutstandingIssues :many
SELECT * FROM sterile.issue
WHERE tenant_id = @tenant_id AND state = 'out'
  AND (@destination::text = '' OR destination = @destination)
ORDER BY issued_at
LIMIT @row_limit;

-- Every issue of every pack in one load, which is the recall's reach
-- (SRS-CSSD-011).
-- name: ListIssuesForCycle :many
SELECT i.* FROM sterile.issue i
JOIN sterile.run r ON r.run_id = i.run_id AND r.tenant_id = i.tenant_id
WHERE i.tenant_id = @tenant_id AND r.cycle_id = @cycle_id
ORDER BY i.run_id, i.issued_at;

-- name: InsertRecall :exec
INSERT INTO sterile.recall (
    recall_id, tenant_id, cycle_id, reason, packs_affected, cases_affected,
    raised_at, raised_by
) VALUES (
    @recall_id, @tenant_id, @cycle_id, @reason, @packs_affected,
    @cases_affected, @raised_at, @raised_by
);

-- name: GetRecall :one
SELECT * FROM sterile.recall WHERE tenant_id = $1 AND recall_id = $2;

-- name: CloseRecall :execrows
UPDATE sterile.recall
SET closed_at = @closed_at, closed_by = @closed_by, closing_note = @closing_note
WHERE tenant_id = @tenant_id AND recall_id = @recall_id
  AND closed_at IS NULL;

-- name: ListOpenRecalls :many
SELECT * FROM sterile.recall
WHERE tenant_id = @tenant_id AND closed_at IS NULL
ORDER BY raised_at
LIMIT @row_limit;
